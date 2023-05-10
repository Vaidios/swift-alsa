import Foundation
import CALSA

public class PCMDevice {
    private var pcm: OpaquePointer?

    public init(device: String = "default", stream: PCMStream = .playback, mode: Int32 = 0) {
        snd_pcm_open(&pcm, device, stream.cType, mode)
    }
    
    public convenience init(format: PCMFormat, access: PCMAccess, channels: UInt32, rate: UInt32, softResample: Int32, latency: UInt32) {
        self.init()
        setParams(format: format.cType, access: access.cType, channels: channels, rate: rate, softResample: softResample, latency: latency)
    }

    deinit {
        if let pcm = pcm {
            snd_pcm_close(pcm)
        }
    }

    public func setParams(format: snd_pcm_format_t, access: snd_pcm_access_t, channels: UInt32, rate: UInt32, softResample: Int32, latency: UInt32) {
        withPCM { pcm in
            snd_pcm_set_params(pcm, format, access, channels, rate, softResample, latency)
        }
    }
    
    public func playBuffer(buffer: UnsafeMutableBufferPointer<Float>, numFrames: Int) {
        withPCM { pcm in
            snd_pcm_writei(pcm, buffer.baseAddress!, snd_pcm_uframes_t(numFrames))
        }
    }

    public func writei(buffer: UnsafeMutableBufferPointer<Float>, numFrames: Int) {
        withPCM { pcm in
            snd_pcm_writei(pcm, buffer.baseAddress!, snd_pcm_uframes_t(numFrames))
        }
    }

    public func drain() {
        withPCM { pcm in
            snd_pcm_drain(pcm)
        }
    }

    private func withPCM<T>(_ closure: (OpaquePointer) -> T) -> T? {
        if let pcm = pcm {
            return closure(pcm)
        }
        return nil
    }
}
