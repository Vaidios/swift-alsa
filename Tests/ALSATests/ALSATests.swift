import XCTest
@testable import ALSA

final class ALSAWrapperTests: XCTestCase {

    func testInitialization() {
        let _ = ALSA()
    }

    func testListDevices() throws {
        let wrapper = ALSA()
        let devices = try wrapper.listDevices()
        
        print("Available ALSA devices:")
        for device in devices {
            print(device)
        }
    }

    func testSineWavePlayback() throws {
        let wrapper = ALSA()
        try wrapper.playSineWave(frequency: 440.0, duration: 3.0)
    }

    func testPassthrough() async throws {
        let passthrough = AudioPassThrough()
        let task = Task { 
            try await passthrough.start()
        }
        try await Task.sleep(for: .seconds(5))
        task.cancel()
    }
}
