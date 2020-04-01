public class UserSession: UserSessionServices {
    public static let current = UserSession()

    private let careTaker: UserSessionCareTaker

    public init(careTaker: UserSessionCareTaker = UserSessionCareTaker()) {
        self.careTaker = careTaker
    }

    public var isLogedIn: Bool {
        (try? careTaker.load().isLogedIn) ?? false
    }

    public var userId: Int? {
        try? careTaker.load().userId
    }

    public var username: String? {
        try? careTaker.load().username
    }

    public var sessionId: String? {
        try? careTaker.load().sessionId
    }

    public var currencyId: Int? {
        try? careTaker.load().currencyId
    }

    public func logout() {
        set(isLoggedIn: false)
    }

    public func set(isLoggedIn: Bool) {
        if var momento = try? careTaker.load() {
            momento.isLogedIn = isLoggedIn
            try? careTaker.save(momento)
        }
    }

    public func set(userId: Int, username: String, sessionId: String, currencyId: Int?) {
        let momento = UserSession.Momento(
            isLogedIn: isLogedIn,
            sessionId: sessionId,
            username: username,
            userId: userId,
            currencyId: currencyId)

        try? careTaker.save(momento)
    }

    public func clear() {
        try? careTaker.save(nil)
        logout()
    }

    public struct Momento: Codable {
        public var isLogedIn: Bool
        public var sessionId: String?
        public var username: String?
        public var userId: Int?
        public var currencyId: Int?
    }
}
