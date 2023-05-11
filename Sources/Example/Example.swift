import ArgumentParser

@main
struct AudioPassthroughExample: AsyncParsableCommand {

    func run() async throws {
        let passthrough = AudioPassThrough()
        try await passthrough.start()
    }
}