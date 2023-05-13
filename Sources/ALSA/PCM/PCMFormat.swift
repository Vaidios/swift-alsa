import CALSA

public enum PCMFormat: CaseIterable {
    case unknown
    case s8
    case u8

    case s16
    case u16

    case s24
    case u24

    case s32
    case u32

    case floatLE
    case floatBE
    case float64LE
    case float64BE

    case float
}

extension PCMFormat {

    var cType: snd_pcm_format_t {
        switch self {
            case .unknown: return SND_PCM_FORMAT_UNKNOWN
            case .s8: return SND_PCM_FORMAT_S8
            case .u8: return SND_PCM_FORMAT_U8

            case .s16: return SND_PCM_FORMAT_S16
            case .u16: return SND_PCM_FORMAT_U16

            case .s24: return SND_PCM_FORMAT_S24
            case .u24: return SND_PCM_FORMAT_U24

            case .s32: return SND_PCM_FORMAT_S32
            case .u32: return SND_PCM_FORMAT_U32

            case .floatLE: return SND_PCM_FORMAT_FLOAT_LE
            case .floatBE: return SND_PCM_FORMAT_FLOAT_BE
            case .float64LE: return SND_PCM_FORMAT_FLOAT64_LE
            case .float64BE: return SND_PCM_FORMAT_FLOAT64_BE

            case .float: return SND_PCM_FORMAT_FLOAT
        }
    }
}