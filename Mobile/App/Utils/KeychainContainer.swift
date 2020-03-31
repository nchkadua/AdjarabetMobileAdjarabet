import Foundation
import SharedFramework

public class KeychainContainer {
    public static let defaultKeychainGroup = "RDJN6C84H4.com.adjarabet.Mobile.credentials"
    public static let shared = KeychainWrapper(serviceName: defaultKeychainGroup, accessGroup: nil)
}
