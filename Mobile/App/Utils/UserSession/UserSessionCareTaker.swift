import Foundation
import SharedFramework

public class UserSessionCareTaker {
    private let storage: KeychainWrapper
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let key: String
    private let accessibility: KeychainItemAccessibility

    public init(
        storage: KeychainWrapper = KeychainContainer.shared,
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder(),
        key: String = "UserSession",
        accessibility: KeychainItemAccessibility = .alwaysThisDeviceOnly) {
        self.storage = storage
        self.decoder = decoder
        self.encoder = encoder
        self.key = key
        self.accessibility = accessibility
    }

    public func save(_ momento: UserSession.Momento?) throws {
        if momento == nil {
            storage.removeObject(forKey: key, withAccessibility: accessibility)
        } else {
            let data = try encoder.encode(momento)
            storage.set(data, forKey: key)
        }

        #if DEBUG
            print(momento ?? "")
        #endif
    }

    public func load() throws -> UserSession.Momento {
        guard let data = storage.data(forKey: key),
            let momento = try? decoder.decode(UserSession.Momento.self, from: data) else {
                throw Error.momentoNotFound
        }

        #if DEBUG
            print(momento)
        #endif
        return momento
    }

    public enum Error: String, Swift.Error {
        case momentoNotFound
    }
}

//    private let userDefaults = UserDefaults(suiteName: "group.com.demo.ajdarabet.AdjarabetMobile.auth")!
