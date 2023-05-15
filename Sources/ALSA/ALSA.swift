import CALSA
import Foundation

public class ALSA {

    public init() {
        snd_lib_error_set_handler(nil)
    }

    deinit {
        snd_config_update_free_global()
    }

    static public func listDevices() throws -> [ALSADeviceInfo] {
        let list = try ALSADevices.getList()
        print(ControlInterface().getSoundCards())
        return list
    }
}