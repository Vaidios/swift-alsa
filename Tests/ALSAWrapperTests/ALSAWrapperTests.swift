import XCTest
@testable import ALSAWrapper

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

    func testPassthrough() throws {
        let passthrough = AudioPassThrough()
        try passthrough.start()
    }
}
