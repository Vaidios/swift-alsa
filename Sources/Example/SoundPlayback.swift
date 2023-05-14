import ALSA
import Foundation

import Foundation

struct WAVFile {

    let sampleRate: Int32
    let channels: Int16
    let bitDepth: Int16
    let filehandle: FileHandle

    init(url: URL) throws {
        let filehandle = try FileHandle(forReadingFrom: url)

        self.filehandle = filehandle

        let sampleRateData = Self.readData(using: filehandle, offset: 24, length: 4)
        self.sampleRate = sampleRateData.withUnsafeBytes { $0.load(as: Int32.self) }

        let channelsData = Self.readData(using: filehandle, offset: 22, length: 2)
        self.channels = channelsData.withUnsafeBytes { $0.load(as: Int16.self) }

        let bitDepthData = Self.readData(using: filehandle, offset: 34, length: 2)
        self.bitDepth = bitDepthData.withUnsafeBytes { $0.load(as: Int16.self) }
    }

    func readData(offset: UInt64, length: Int) -> Data {
        self.filehandle.seek(toFileOffset: offset)
        return self.filehandle.readData(ofLength: length)
    }

    static func readData(using filehandle: FileHandle, offset: UInt64, length: Int) -> Data {
        filehandle.seek(toFileOffset: offset)
        return filehandle.readData(ofLength: length)
    }
}


struct SoundPlayback {

    func run() throws {
        guard let audioFilepath = Bundle.module.path(forResource: "applaus", ofType: "wav") else {
            fatalError()
        }

        let url = URL(fileURLWithPath: audioFilepath)
        print(url)
        let wavFile = try WAVFile(url: url)
        print("Sample rate: \(wavFile.sampleRate)")
        print("Channels: \(wavFile.channels)")
        print("Bit depth: \(wavFile.bitDepth)")

        let rate: UInt32 = 44100

        let pcm = try PCMDevice(device: "plughw:CARD=Device,DEV=0", stream: .playback, mode: 0)
        
        try pcm.setAccess(.rwInterleaved)
        try pcm.setFormat(.s16)
        try pcm.setChannels(2)
        try pcm.setRateNear(rate)

        print("PCM name: \(pcm.name)")
        print("PCM state: \(pcm.state)")
        let channels = try pcm.getChannels()
        print(" channels: \(channels)")
        print(" rate: \(try pcm.getRate()) bps")

        let periodTime = try pcm.getPeriodTime()
        print("Period time \(periodTime)")

        let microSecondTransform = 1_000_000
        let seconds = 5
        let numberOfLoops = seconds * microSecondTransform / Int(periodTime)
        print("number of loops is \(numberOfLoops)")

        let framesPerBuffer: Int = 1024  // adjust as needed
        let bytesPerFrame = wavFile.channels * (wavFile.bitDepth / 8)
        let bufferSize = framesPerBuffer * Int(bytesPerFrame)
        while true {
            let bufferData = wavFile.readData(offset: try wavFile.filehandle.offset(), length: bufferSize)
            if bufferData.count == 0 {
                print("End of file")
                break
            }
            var bufferArray = Array(bufferData)
            try bufferArray.withUnsafeMutableBufferPointer { buffer in
                let frameCount = buffer.count / Int(bytesPerFrame)
                try pcm.write(buffer: buffer.baseAddress!, frameCount: UInt(frameCount))
            }
        }

    }
}