import CALSA

public enum PCMStream {
    case playback
}

extension PCMStream {

    var cType: snd_pcm_stream_t {
        switch self {
            case .playback: return SND_PCM_STREAM_PLAYBACK
        }
    }
}