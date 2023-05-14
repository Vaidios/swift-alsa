import ALSA
import Foundation

import Foundation

class WAVFile {
    let sampleRate: Int
    let channels: Int
    let bitDepth: Int

    let data: Data

    init?(url: URL) {
        let fileData: Data
        do {
            fileData = try Data(contentsOf: url)
        } catch {
            print("Error reading file: \(error)")
            return nil
        }

        // Parse WAV header
        guard fileData.count >= 44 else {
            print("File is too small to be a valid WAV file")
            return nil
        }

        let sampleRateData = fileData[24..<28]
        sampleRate = sampleRateData.withUnsafeBytes { $0.load(as: Int.self) }

        let channelsData = fileData[22..<24]
        channels = channelsData.withUnsafeBytes { $0.load(as: Int.self) }

        let bitDepthData = fileData[34..<36]
        bitDepth = bitDepthData.withUnsafeBytes { $0.load(as: Int.self) }

        // The audio data starts at byte 44 in a WAV file
        data = fileData[44...]
    }
}


struct SoundPlayback {

    func run() throws {
        guard let audioFilepath = Bundle.module.path(forResource: "applaus", ofType: "wav") else {
            fatalError()
        }
        guard let url = URL(string: audioFilepath) else {
            fatalError()
        }
        if let wavFile = WAVFile(url: url) {
            print("Sample rate: \(wavFile.sampleRate)")
            print("Channels: \(wavFile.channels)")
            print("Bit depth: \(wavFile.bitDepth)")
        }
        let handle = try FileHandle(forReadingFrom: url)

        // let devices = try ALSA.listDevices()
        // for device in devices {
        //     print(device)
        // }

        let rate: UInt32 = 44100

        let pcm = try PCMDevice(device: "plughw:CARD=Device,DEV=0", stream: .playback, mode: 0)
        
        try pcm.setAccess(.rwInterleaved)
        try pcm.setFormat(.s8)
        try pcm.setChannels(1)
        try pcm.setRateNear(rate)

        print("PCM name: \(pcm.name)")
        print("PCM state: \(pcm.state)")
        let channels = try pcm.getChannels()
        print(" channels: \(channels)")
        print(" rate: \(try pcm.getRate()) bps")

        let frames = try pcm.getPeriodSize()
        let bufferSize = frames * UInt(channels) * 2

        let periodTime = try pcm.getPeriodTime()
        print("Period time \(periodTime)")

        let microSecondTransform = 1_000_000
        let seconds = 5
        let numberOfLoops = seconds * microSecondTransform / Int(periodTime)
        print("number of loops is \(numberOfLoops)")

        for loop in 0 ..< numberOfLoops {

        }
    }
}