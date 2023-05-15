import CALSA

final class HardwareParameters {

    private var access: PCMAccess?
    private var format: PCMFormat?
    private var channels: UInt32?
    private var rateNear: UInt32?
    private var bufferTimeNear: UInt32?
    private var periodTimeNear: UInt32?

    private let pcm: OpaquePointer
    private let params: OpaquePointer

    init(pcm: OpaquePointer) throws {
        self.pcm = pcm
        var params: OpaquePointer?
        let mallocErr = snd_pcm_hw_params_malloc(&params)
        if mallocErr < 0 { 
            let description = String(cString: snd_strerror(mallocErr))
            throw ALSAError(code: mallocErr, description: description)
        }

        let setupErr = snd_pcm_hw_params_any(pcm, params)
        if setupErr < 0 { 
            let description = String(cString: snd_strerror(setupErr))
            throw ALSAError(code: setupErr, description: description)
        }
        guard let params else { throw PCMDeviceError.hardwareParametersCreationFailed }
        self.params = params
    }

    func setAccess(_ access: PCMAccess) throws {
        self.access = access
        try setParameters()
    }

    func setFormat(_ format: PCMFormat) throws {
        self.format = format
        try setParameters()
    }

    func setChannels(_ channels: UInt32) throws {
        self.channels = channels
        try setParameters()
    }

    func setRateNear(_ rate: UInt32) throws {
        self.rateNear = rate
        try setParameters()
    }

    func setBufferTimeNear(_ bufferTime: UInt32) throws {
        self.bufferTimeNear = bufferTime
        try setParameters()
    }

    func setPeriodTimeNear(_ periodTime: UInt32) throws { 
        self.periodTimeNear = periodTime
        try setParameters()
    }

    public func getChannels() throws -> UInt32 {
        var channels: UInt32 = 0
        let err = snd_pcm_hw_params_get_channels(params, &channels)
        if err < 0 { 
            let description = String(cString: snd_strerror(err))
            throw ALSAError(code: err, description: description)
        }
        return channels
    }

    public func getRate() throws -> UInt32 {
        var rate: UInt32 = 0
        var dir: Int32 = 0
        let err = snd_pcm_hw_params_get_rate(params, &rate, &dir)
        if err < 0 { 
            let description = String(cString: snd_strerror(err))
            throw ALSAError(code: err, description: description)
        }
        return rate
    }

    public func getPeriodTime() throws -> UInt32 {
        var periodTime: UInt32 = 0
        var dir: Int32 = 0
        let err = snd_pcm_hw_params_get_period_time(params, &periodTime, &dir)
        if err < 0 { 
            let description = String(cString: snd_strerror(err))
            throw ALSAError(code: err, description: description)
        }
        return periodTime
    }

    public func getPeriodSize() throws -> UInt {
        var frames: snd_pcm_uframes_t = 0
        var dir: Int32 = 0
        let err = snd_pcm_hw_params_get_period_size(params, &frames, &dir)
        if err < 0 { 
            let description = String(cString: snd_strerror(err))
            throw ALSAError(code: err, description: description)
        }
        return frames
    }
}

private extension HardwareParameters {
    private func makeFreshParameters() throws {
        let setupErr = snd_pcm_hw_params_any(pcm, params)
        if setupErr < 0 { 
            let description = String(cString: snd_strerror(setupErr))
            throw ALSAError(code: setupErr, description: description)
        }
    }

    private func _setAccess(_ access: snd_pcm_access_t) throws {
        let err = snd_pcm_hw_params_set_access(pcm, params, access)
        if err < 0 { 
            let description = String(cString: snd_strerror(err))
            throw ALSAError(code: err, description: description)
        }
    }

    private func _setFormat(_ format: snd_pcm_format_t) throws {
        let err = snd_pcm_hw_params_set_format(pcm, params, format)
        if err < 0 { 
            let description = String(cString: snd_strerror(err))
            throw ALSAError(code: err, description: description)
        }
    }

    private func _setChannels(_ channels: UInt32) throws {
        let err = snd_pcm_hw_params_set_channels(pcm, params, channels)
        if err < 0 { 
            let description = String(cString: snd_strerror(err))
            throw ALSAError(code: err, description: description)
        }
    }

    private func _setRateNear(_ rate: UInt32) throws {
        var rate: UInt32 = rate
        var dir: Int32 = 0
        let err = snd_pcm_hw_params_set_rate_near(pcm, params, &rate, &dir)
        if err < 0 { 
            let description = String(cString: snd_strerror(err))
            throw ALSAError(code: err, description: description)
        }
    }

    private func _setBufferTimeNear(_ bufferTime: UInt32) throws {
        var bufferTime: UInt32 = bufferTime
        var dir: Int32 = 0
        let err = snd_pcm_hw_params_set_buffer_time_near(pcm, params, &bufferTime, &dir)
        if err < 0 { 
            let description = String(cString: snd_strerror(err))
            throw ALSAError(code: err, description: description)
        }   
    }

    private func _setPeriodTimeNear(_ periodTime: UInt32) throws {
        var periodTime: UInt32 = periodTime
        var dir: Int32 = 0
        let err = snd_pcm_hw_params_set_period_time_near(pcm, params, &periodTime, &dir)
        if err < 0 { 
            let description = String(cString: snd_strerror(err))
            throw ALSAError(code: err, description: description)
        }   
    }

    private func saveParameters() throws {
        let err = snd_pcm_hw_params(pcm, params)
        if err < 0 { 
            let description = String(cString: snd_strerror(err))
            throw ALSAError(code: err, description: description)
        }
    }

    private func setParameters() throws {
        try makeFreshParameters()
        if let access {
            try _setAccess(access.cType)
        }
        if let format {
            try _setFormat(format.cType)
        }
        if let channels {
            try _setChannels(channels)
        }
        if let rateNear {
            try _setRateNear(rateNear)
        }
        if let bufferTimeNear {
            try _setBufferTimeNear(bufferTimeNear)
        }
        if let periodTimeNear {
            try _setPeriodTimeNear(periodTimeNear)
        }

        try saveParameters()
    }
}