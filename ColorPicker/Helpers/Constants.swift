import Foundation

enum Constants {
    private enum BundleKey: String {
        case appName = "CFBundleName"
        case appVersion = "CFBundleShortVersionString"
    }
    
    static let appName: String = {
        valueFromBundle(for: .appName) ?? defaultAppName
    }()
    
    static let appVersionString: String = {
        valueFromBundle(for: .appVersion) ?? defaultAppVersionString
    }()
    
    static let appVersion: (major: Int, minor: Int, patch: Int) = {
        let subVersions = appVersionString.split(separator: ".").compactMap { Int($0) }
        
        switch subVersions.count {
        case 3...:
            return (subVersions[0], subVersions[1], subVersions[2])
        case 2:
            return (subVersions[0], subVersions[1], 0)
        case 1:
            return (subVersions[0], 0, 0)
        default:
            return (1, 0, 0)
        }
    }()
    
    static let appBundleId: String = {
        Bundle.main.bundleIdentifier ?? defaultAppBundleId
    }()
    
    static let recentColorKey = "most_recent_color"
    
    // MARK: - Private
    
    static private let defaultAppName = "ColorPicker"
    static private let defaultAppVersionString = "1.0"
    static private let defaultAppBundleId = "com.mazjap.colorpicker"
    
    static private func valueFromBundle<Value>(for key: BundleKey) -> Value? {
        Bundle.main.infoDictionary?[key.rawValue] as? Value
    }
}
