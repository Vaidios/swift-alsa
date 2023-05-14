import Foundation
import CALSA

enum PCMDeviceError: Error {
    case notAvailable
    case invalidState
    case overrunOccured
    case underrunOccured
    case suspendEventOccured
    case setAccessFailed
    case hardwareParametersCreationFailed
    case unknown
}

struct ALSAError: Error {
    let code: Int32
    let description: String
}

public class PCMDevice { 

    public var name: String { String(cString: snd_pcm_name(pcm)) }
    public var state: String { String(cString: snd_pcm_state_name(snd_pcm_state(pcm))) }

    internal let pcm: OpaquePointer
    internal let hwParams: HardwareParameters
    internal var params: OpaquePointer?

    public init(device: String = "default", stream: PCMStream = .playback, mode: Int32 = 0) throws {
        var tempPCM: OpaquePointer?
        let err = snd_pcm_open(&tempPCM, device, stream.cType, mode)
        if err < 0 { 
            let description = String(cString: snd_strerror(err))
            throw ALSAError(code: err, description: description)
        }
        guard let tempPCM else { throw PCMDeviceError.notAvailable }
        self.pcm = tempPCM
        self.hwParams = try HardwareParameters(pcm: pcm)
        // setupParamsPtr()
    }
    
    public convenience init(format: PCMFormat, access: PCMAccess, channels: UInt32, rate: UInt32, softResample: Int32, latency: UInt32) throws {
        try self.init()
        setParams(format: format, access: access, channels: channels, rate: rate, softResample: softResample, latency: latency)
    }

    func setupParamsPtr() {
        snd_pcm_hw_params_malloc(&params)
        snd_pcm_hw_params_any(pcm, params)
    }

    deinit {
        snd_pcm_drop(pcm)
        snd_pcm_close(pcm)
    }

    public func setParams(format: PCMFormat, access: PCMAccess, channels: UInt32, rate: UInt32, softResample: Int32, latency: UInt32) {
        snd_pcm_set_params(pcm, format.cType, access.cType, channels, rate, softResample, latency)
    }

    public func setAccess(_ access: PCMAccess) throws { try hwParams.setAccess(access) }
    public func setFormat(_ format: PCMFormat) throws { try hwParams.setFormat(format) }
    public func setChannels(_ channels: UInt32) throws { try hwParams.setChannels(channels) }
    public func getChannels() throws -> UInt32 { try hwParams.getChannels() }
    public func setRateNear(_ rate: UInt32) throws { try hwParams.setRateNear(rate) }
    public func getRate() throws -> UInt32 { try hwParams.getRate() }
    public func getPeriodTime() throws -> UInt32 { try hwParams.getPeriodTime() }
    public func getPeriodSize() throws -> UInt { try hwParams.getPeriodSize() }

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
