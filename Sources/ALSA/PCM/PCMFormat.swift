import CALSA

public enum PCMFormat {
    case float
    case s16LE
}

extension PCMFormat {

    var cType: snd_pcm_format_t {
        switch self {
            case .float: return SND_PCM_FORMAT_FLOAT
            case .s16LE: return SND_PCM_FORMAT_S16_LE
        }
    }
}