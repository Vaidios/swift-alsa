import CALSA

public enum PCMFormat {
    case float
}

extension PCMFormat {

    var cType: snd_pcm_format_t {
        switch self {
            case .float: return SND_PCM_FORMAT_FLOAT
        }
    }
}