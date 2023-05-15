import ArgumentParser
import ALSA

@main
struct Examples: AsyncParsableCommand {

    func run() async throws {

        for device in try ALSA.listDevices() {
            print(device)
        }
        // Task {
        //     let audioPassThrough = try AudioPassThrough()
        //     try await audioPassThrough.run()
        // }

        Task {
            let playback = SoundPlayback()
            try playback.run()
        }


        try await Task.sleep(for: .seconds(30))
    }
}