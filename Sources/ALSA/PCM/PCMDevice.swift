import Foundation
import CALSA

enum PCMDeviceError: Error {
    case notAvailable
    case invalidState
    case overrunOccured
    case underrunOccured
    case suspendEventOccured
    case unknown
}

public class PCMDevice {

    // private var pcm: OpaquePointer { _pcm! }
    private var pcm: OpaquePointer?

    public init(device: String = "default", stream: PCMStream = .playback, mode: Int32 = 0) throws {
        snd_pcm_open(&pcm, device, stream.cType, mode)
    }
    
    public convenience init(format: PCMFormat, access: PCMAccess, channels: UInt32, rate: UInt32, softResample: Int32, latency: UInt32) throws {
        try self.init()
        setParams(format: format, access: access, channels: channels, rate: rate, softResample: softResample, latency: latency)
    }

    deinit {
        snd_pcm_drop(pcm)
        snd_pcm_close(pcm)
        print("PCM device deinit")
    }

    public func setParams(format: PCMFormat, access: PCMAccess, channels: UInt32, rate: UInt32, softResample: Int32, latency: UInt32) {
        snd_pcm_set_params(pcm, format.cType, access.cType, channels, rate, softResample, latency)
        var hwParams: OpaquePointer?
        snd_pcm_hw_params_malloc(&hwParams)
        snd_pcm_hw_params_any(pcm, hwParams)
    }

    public func setHardwareParams(format: PCMFormat, access: PCMAccess, rate: inout UInt32, channels: UInt32, bufferTime: inout UInt32, periodTime: inout UInt32) {
        var params: OpaquePointer?
        snd_pcm_hw_params_malloc(&params)
        snd_pcm_hw_params_any(pcm, params)
        snd_pcm_hw_params_set_format(pcm, params, format.cType)
        snd_pcm_hw_params_set_access(pcm, params, access.cType)
        snd_pcm_hw_params_set_rate_near(pcm, params, &rate, nil)
        snd_pcm_hw_params_set_channels(pcm, params, channels)
        snd_pcm_hw_params_set_buffer_time_near(pcm, params, &bufferTime, nil)
        snd_pcm_hw_params_set_period_time_near(pcm, params, &periodTime, nil)
        snd_pcm_hw_params(pcm, params)
    }
    
    public func playBuffer(buffer: UnsafeMutableBufferPointer<Float>, numFrames: Int) {
        snd_pcm_writei(pcm, buffer.baseAddress!, snd_pcm_uframes_t(numFrames))
    }

    public func prepare() throws {
        snd_pcm_prepare(pcm)
    }

    public func read(buffer: UnsafeMutableRawPointer, frameCount: UInt) throws -> Int {
        let result = snd_pcm_readi(pcm, buffer, frameCount)
            guard result < 0 else { return result } 
            switch Int32(result) {
            case -EBADFD:
                throw PCMDeviceError.invalidState
            case -EPIPE:
                snd_pcm_prepare(pcm)
                throw PCMDeviceError.overrunOccured
            case -ESTRPIPE:
                throw PCMDeviceError.suspendEventOccured
            default:
                throw PCMDeviceError.unknown
            }
    }

    public func write(buffer: UnsafeMutableRawPointer, frameCount: UInt) throws -> Int {
        let result = snd_pcm_writei(pcm, buffer, frameCount)
        guard result < 0 else { return result } 
        switch Int32(result) {
            case -EBADFD:
                throw PCMDeviceError.invalidState
            case -EPIPE:
                throw PCMDeviceError.underrunOccured
            case -ESTRPIPE:
                throw PCMDeviceError.suspendEventOccured
            default:
                throw PCMDeviceError.unknown
        }
    }

    public func drain() {
        snd_pcm_drain(pcm)
    }
}
