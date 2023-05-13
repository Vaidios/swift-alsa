import CALSA

public extension PCMDevice {
    public func printFormatSupport() throws {
        print("Format supports")
        for format in PCMFormat.allCases {
            if format == .unknown { continue }
            let value = snd_pcm_hw_params_test_format(pcm, params, format.cType)
            let isSupported = value == 0
            print("Format: \(format) - \(isSupported)")
        }
    }

    public func printAccessSupport() throws {
        print("Access support")
        for format in PCMAccess.allCases {
            let value = snd_pcm_hw_params_test_access(pcm, params, format.cType)
            let isSupported = value == 0
            print("Format: \(format) - \(isSupported)")
        }
    }

    public func printSupportedChannels() throws {
        var minChannels: UInt32 = 0
        var maxChannels: UInt32 = 0

        let minErr = snd_pcm_hw_params_get_channels_min(params, &minChannels)
        if minErr < 0 {
            let description = String(cString: snd_strerror(minErr))
            throw ALSAError(code: minErr, description: description)
        }

        let maxErr = snd_pcm_hw_params_get_channels_max(params, &maxChannels)
        if maxErr < 0 {
            let description = String(cString: snd_strerror(maxErr))
            throw ALSAError(code: maxErr, description: description)
        }

        print("Supported channels: \(minChannels) to \(maxChannels)")
    }

    public func printSupportedSampleRates() throws {
    var minRate: UInt32 = 0
    var maxRate: UInt32 = 0
    var dir: Int32 = 0

    let minErr = snd_pcm_hw_params_get_rate_min(params, &minRate, &dir)
    if minErr < 0 {
        let description = String(cString: snd_strerror(minErr))
        throw ALSAError(code: minErr, description: description)
    }

    let maxErr = snd_pcm_hw_params_get_rate_max(params, &maxRate, &dir)
    if maxErr < 0 {
        let description = String(cString: snd_strerror(maxErr))
        throw ALSAError(code: maxErr, description: description)
    }

    print("Supported sample rates: \(minRate) to \(maxRate) Hz")
}
}