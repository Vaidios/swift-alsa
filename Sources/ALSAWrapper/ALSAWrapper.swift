import CALSA
import Foundation

public class ALSA {

    public init() {
        snd_lib_error_set_handler(nil)
    }

    deinit {
        snd_config_update_free_global()
    }

    public func listDevices() throws -> [ALSADeviceInfo] {
        let list = try ALSADevices.getList()
        print(ControlInterface().getSoundCards())
        return list
    }

    public func playWAVFile(_ wavFile: WAVFile) throws {
        let bufferFrames = 1024
        let numChannels: UInt32 = 1
        
        let pcmDevice = try PCMDevice(format: .float, access: .readWriteInterleaved, channels: numChannels, rate: wavFile.sampleRate, softResample: 1, latency: 500000)
        
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

    public func playSineWave(frequency: Float = 440.0, duration: TimeInterval = 5.0) throws {
        let sampleRate: UInt32 = 44100
        let bufferFrames: Int = 1024
        let numChannels: UInt32 = 1

        let pcmDevice = try PCMDevice(device: "plughw:CARD=Device,DEV=0")
        pcmDevice.setParams(format: .float, access: .readWriteInterleaved, channels: numChannels, rate: sampleRate, softResample: 1, latency: 500000)

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
            try pcmDevice.write(buffer: buffer.baseAddress!, frameCount: UInt(bufferFrames))
        }

        pcmDevice.drain()
    }
}