import CALSA

public enum ALSADevicesError: Error {
    case deviceListError(Int32)
}

public struct ALSADevices {

    static func getList() throws -> [ALSADeviceInfo] {
        var deviceList: [ALSADeviceInfo] = []
        var deviceHints: UnsafeMutablePointer<UnsafeMutableRawPointer?>?
        let status = snd_device_name_hint(-1, "pcm", &deviceHints)

    guard status >= 0, let hints = deviceHints else {
        throw ALSADevicesError.deviceListError(status)
    }

    defer { snd_device_name_free_hint(hints) }

    var i = 0
    while let hint = hints.advanced(by: i).pointee {
        if let name = String(cString: snd_device_name_get_hint(hint, "NAME"), encoding: .utf8),
           let desc = String(cString: snd_device_name_get_hint(hint, "DESC"), encoding: .utf8) {
            let deviceInfo = ALSADeviceInfo(name: name, description: desc, deviceId: name)
            deviceList.append(deviceInfo)
        }
        i += 1
    }

    return deviceList
    }
}