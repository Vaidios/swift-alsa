import XCTest
@testable import ALSAWrapper

final class ALSAWrapperTests: XCTestCase {

    func testInitialization() {
        let _ = ALSACore()
    }

    func testListDevices() {
        let wrapper = ALSACore()
        let devices = wrapper.listDevices()
        
        print("Available ALSA devices:")
        for device in devices {
            print(device)
        }
    }

    func testSineWavePlayback() {
        let wrapper = ALSACore()
        wrapper.playSineWave(frequency: 440.0, duration: 2.0)
    }
}
