import XCTest
@testable import ALSA

final class PCMDeviceTests: XCTestCase {

    func testPCMDeviceInitializationError() async throws {
        
        do {
            let _ = try PCMDevice(device: "non-existent-device", stream: .capture, mode: 1)
        } catch {
            guard let error = error as? PCMDeviceError else { XCTFail("PCM Device did not return PCMDeviceError"); return }
            guard case .invalidDeviceChosen = error else { XCTFail("PCMDeviceError is not invalidDeviceChosen"); return }
        }
        
    }
}
