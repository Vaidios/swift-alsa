import CALSA
import Foundation

public class ALSACore {

    public init() {
        snd_lib_error_set_handler(nil)
    }

    deinit {
        snd_config_update_free_global()
    }

    public func listDevices() -> [String] {
        var rawDeviceHints: UnsafeMutablePointer<UnsafeMutableRawPointer?>?
        var deviceNames: [String] = []

        guard snd_device_name_hint(-1, "pcm", &rawDeviceHints) >= 0 else {
            return deviceNames
        }

        var index = 0
        while let deviceHint = rawDeviceHints?[index] {
            if let name = snd_device_name_get_hint(deviceHint, "NAME"),
                let description = snd_device_name_get_hint(deviceHint, "DESC") {
                let deviceName = String(cString: name)
                let deviceDescription = String(cString: description).replacingOccurrences(of: "\n", with: " ")
                deviceNames.append("\(deviceName): \(deviceDescription)")

                free(name)
                free(description)
            }
            index += 1
        }

        snd_device_name_free_hint(rawDeviceHints)

        return deviceNames
    }

    public func playWAVFile(_ wavFile: WAVFile) {
        let bufferFrames = 1024
        let numChannels: UInt32 = 1
        
        let pcmDevice = PCMDevice(format: .float, access: .readWriteInterleaved, channels: numChannels, rate: wavFile.sampleRate, softResample: 1, latency: 500000)
        
        let bufferLength = bufferFrames * MemoryLayout<Float>.size
        let buffer = UnsafeMutableBufferPointer<Float>.allocate(capacity: bufferLength)
        defer { buffer.deallocate() }
        
        let numSamples = wavFile.samples.count
        var sampleIndex = 0
        
        while sampleIndex < numSamples {
            let remainingSamples = numSamples - sampleIndex
            let framesToWrite = min(bufferFrames, remainingSamples)
            
            for frame in 0..<framesToWrite {
                buffer[frame] = wavFile.samples[sampleIndex]
                sampleIndex += 1
            }
            
            pcmDevice.playBuffer(buffer: buffer, numFrames: framesToWrite)
        }
        
        pcmDevice.drain()
    }

    public func playSineWave(frequency: Float = 440.0, duration: TimeInterval = 5.0) {
        let sampleRate: UInt32 = 44100
        let bufferFrames: Int = 1024
        let numChannels: UInt32 = 1

        let pcmDevice = PCMDevice()
        pcmDevice.setParams(format: SND_PCM_FORMAT_FLOAT, access: SND_PCM_ACCESS_RW_INTERLEAVED, channels: numChannels, rate: sampleRate, softResample: 1, latency: 500000)

        let bufferLength = bufferFrames * MemoryLayout<Float>.size
        let buffer = UnsafeMutableBufferPointer<Float>.allocate(capacity: bufferLength)
        defer { buffer.deallocate() }

        let numSamples = UInt32(duration * Double(sampleRate))
        let twoPi = 2.0 * Float.pi
        let increment = twoPi * frequency / Float(sampleRate)

        for sampleIndex in stride(from: UInt32(0), to: numSamples, by: bufferFrames) {
            for frame in 0..<bufferFrames {
                buffer[Int(frame)] = sin(Float(sampleIndex + UInt32(frame)) * increment)
            }
            pcmDevice.writei(buffer: buffer, numFrames: bufferFrames)
        }

        pcmDevice.drain()
    }
}