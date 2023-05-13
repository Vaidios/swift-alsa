import ALSA

struct SoundPlayback {

    func run() throws {

        let devices = try ALSA.listDevices()
        for device in devices {
            print(device)
        }

        var rate: UInt32 = 44100

        let pcm = try PCMDevice(device: "plughw:CARD=Device,DEV=0", stream: .playback, mode: 0)
        
        try pcm.printAccessSupport()
        try pcm.setAccess(.rwInterleaved)

        try pcm.printFormatSupport()
        try pcm.setFormat(.s8)

        try pcm.printSupportedChannels()
        try pcm.setChannels(1)

        try pcm.printSupportedSampleRates()
        try pcm.setRateNear(&rate)

        print("PCM name: \(pcm.name)")
        print("PCM state: \(pcm.state)")
        print(" channels: \(try pcm.getChannels())")
        print(" rate: \(try pcm.getRate()) bps")

        let periodTime = try pcm.getPeriodTime()
        print("Period time \(periodTime)")
    }
}