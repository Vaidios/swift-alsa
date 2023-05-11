import ArgumentParser

@main
struct AudioPassthroughExample: AsyncParsableCommand {

    func run() async throws {
        let passthrough = try AudioPassThrough()
        try await passthrough.start()
    }
}