import ArgumentParser
import ALSA

@main
struct Example: AsyncParsableCommand {


    func run() async throws {
        print("Command")
        
        let task = Task {
            let passthrough = AudioPassThrough()
            try await passthrough.start()

        }
        try await Task.sleep(for: .seconds(2))
        task.cancel()
    }
}