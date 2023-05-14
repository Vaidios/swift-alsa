import ALSA

struct SoundPlayback {

    func run() throws {

        let devices = try ALSA.listDevices()
        for device in devices {
            print(device)
        }

        let rate: UInt32 = 44100

        let pcm = try PCMDevice(device: "plughw:CARD=Device,DEV=0", stream: .playback, mode: 0)
        
        try pcm.setAccess(.rwInterleaved)
        try pcm.setFormat(.s8)
        try pcm.setChannels(1)
        try pcm.setRateNear(rate)

        print("PCM name: \(pcm.name)")
        print("PCM state: \(pcm.state)")
        let channels = try pcm.getChannels()
        print(" channels: \(channels)")
        print(" rate: \(try pcm.getRate()) bps")



        let frames = try pcm.getPeriodSize()
        let bufferSize = frames * UInt(channels) * 2

        let periodTime = try pcm.getPeriodTime()
        print("Period time \(periodTime)")
    }
}