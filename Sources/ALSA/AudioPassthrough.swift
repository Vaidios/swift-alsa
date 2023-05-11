import Foundation

public class AudioPassThrough {
    let wrapper: ALSA
    var capturePCM: OpaquePointer?
    var playbackPCM: OpaquePointer?

    public init() {
        wrapper = ALSA()
    }

    public func start() async throws {
        // Open the capture device (microphone)
        let capturePCM = try PCMDevice(device: "plughw:CARD=Device,DEV=0", stream: .capture, mode: 0)
        let playbackPCM = try PCMDevice(device: "plughw:CARD=Device,DEV=0", stream: .playback, mode: 0)

        // Set up the PCM parameters
        let format: PCMFormat = .s16LE
        let channels: UInt32 = 2
        var rate:UInt32 = 44100
        var bufferTime: UInt32 = 200000 // 0.5 seconds
        var periodTime: UInt32 = 100000 // 0.1 seconds
        capturePCM.setHardwareParams(format: format, access: .readWriteInterleaved, rate: &rate, channels: channels, bufferTime: &bufferTime, periodTime: &periodTime)
        playbackPCM.setHardwareParams(format: format, access: .readWriteInterleaved, rate: &rate, channels: channels, bufferTime: &bufferTime, periodTime: &periodTime)

        // Set up a buffer for the audio data
        let framesPerPeriod = rate / 10 // 10 periods per second
        let bufferSize = framesPerPeriod * channels * 2 // 2 bytes per sample for SND_PCM_FORMAT_S16_LE
        let buffer = UnsafeMutableBufferPointer<Int8>.allocate(capacity: Int(bufferSize))
        defer {  buffer.deallocate() }
        
        try capturePCM.prepare()
        try playbackPCM.prepare()
        // In a loop, read audio data from the capture device and write it to the playback device
        while true {
            try Task.checkCancellation()
            do {
                let framesRead = try capturePCM.read(buffer: buffer.baseAddress!, frameCount: UInt(framesPerPeriod))
                let framesWritten = try playbackPCM.write(buffer: buffer.baseAddress!, frameCount: UInt(framesPerPeriod))
            } catch {
                print("error: \(error)")
                
            }
        }
    }
}
