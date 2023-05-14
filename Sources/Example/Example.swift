import ArgumentParser

@main
struct Examples: AsyncParsableCommand {

    func run() async throws {

        // let audioPassThrough = try AudioPassThrough()
        // try await audioPassThrough.run()

        let playback = SoundPlayback()
        try playback.run()
        
    }
}