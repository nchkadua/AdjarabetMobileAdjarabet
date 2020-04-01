public class AdjarabetCoreResult {
}

public extension AdjarabetCoreResult {
    struct Header {
        public struct Empty: HeaderProtocol {
            public init(headers: [AnyHashable: Any]?) throws { }
        }

        public struct Login: HeaderProtocol {
            public let sessionId: String

            public init(headers: [AnyHashable: Any]?) throws {
                guard let cookie = headers?["Set-Cookie"] as? String else {
                    throw AdjarabetCoreClientError.invalidHeader(context: headers)
                }

                let split = cookie.split(separator: ";")

                if let sessionId = split.first(where: { $0.contains("JSESSIONID=") }) {
                    self.sessionId = String(sessionId)
                    print(self.sessionId)
                } else {
                    throw AdjarabetCoreClientError.invalidHeader(context: headers)
                }
            }
        }
    }
}

public extension AdjarabetCoreResult {
    struct Result<C: Codable, H: HeaderProtocol>: AdjarabetCoreCodableType {
        public let codable: C
        public let header: H?

        public init(codable: C, header: H?) {
            self.codable = codable
            self.header = header
        }
    }

    typealias Login = Result<AdjarabetCoreCodable.Authentication.Login, AdjarabetCoreResult.Header.Login>
    typealias Logout = Result<AdjarabetCoreCodable.Empty, AdjarabetCoreResult.Header.Empty>
    typealias AliveSession = Result<AdjarabetCoreCodable.AliveSession, AdjarabetCoreResult.Header.Empty>
    typealias Balance = Result<AdjarabetCoreCodable.Balance, AdjarabetCoreResult.Header.Empty>
    typealias SmsCode = Result<AdjarabetCoreCodable.Authentication.SmsCode, AdjarabetCoreResult.Header.Empty>
}
