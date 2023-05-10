import CALSA

public enum PCMAccess {
    case readWriteInterleaved
}

extension PCMAccess {

    var cType: snd_pcm_access_t {
        switch self {
            case .readWriteInterleaved: return SND_PCM_ACCESS_RW_INTERLEAVED
        }
    }
}