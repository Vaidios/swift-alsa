import CALSA

public enum PCMStream {
    case capture
    case playback
}

extension PCMStream {

    var cType: snd_pcm_stream_t {
        switch self {
            case .capture: return SND_PCM_STREAM_CAPTURE
            case .playback: return SND_PCM_STREAM_PLAYBACK
        }
    }
}