import CALSA

public enum PCMAccess: CaseIterable {
    case mmapInterleaved
    case mmapNoninterleaved
    case mmapComplex
    case rwInterleaved
    case rwNoninterleaved
}

extension PCMAccess {

    var cType: snd_pcm_access_t {
        switch self {
            case .mmapInterleaved: return SND_PCM_ACCESS_MMAP_INTERLEAVED
            case .mmapNoninterleaved: return SND_PCM_ACCESS_MMAP_NONINTERLEAVED
            case .mmapComplex: return SND_PCM_ACCESS_MMAP_COMPLEX
            case .rwInterleaved: return SND_PCM_ACCESS_RW_INTERLEAVED
            case .rwNoninterleaved: return SND_PCM_ACCESS_RW_NONINTERLEAVED
        }
    }
}