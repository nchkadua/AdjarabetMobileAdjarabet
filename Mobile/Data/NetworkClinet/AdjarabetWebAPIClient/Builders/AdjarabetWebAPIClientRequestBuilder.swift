public extension AdjarabetWebAPIClient {
    var standartRequestBuilder: RequestBuilder {
        return RequestBuilder(url: baseUrl)
    }

    class RequestBuilder: Builder {
        public typealias Buildable = URLRequest

        private var url: URL
        private var queryItems: [URLQueryItem] = []
        private var headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Origin": "https://www.adjarabet.com",
            "Referer": "https://www.adjarabet.com/ka",
            "X-Requested-With": "XMLHttpRequest"
        ]

        public init(url: URL) {
            self.url = url
        }

        public func set(method: Method) -> Self {
            url.appendPathComponent(method.rawValue)
            return self
        }

        public func set(userId: Int, domain: String) -> Self {
            queryItems.append(URLQueryItem(name: Key.userId.rawValue, value: "\(userId)"))
            queryItems.append(URLQueryItem(name: Key.domain.rawValue, value: domain))
            return self
        }

        public func setHeader(key: HeaderKey, value: String) -> Self {
            headers[key.rawValue] = value
            return self
        }

        public func build() -> URLRequest {
            var component = URLComponents(url: url, resolvingAgainstBaseURL: false)
            component?.queryItems = queryItems

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = component?.query?.data(using: String.Encoding.utf8)

            print(component ?? "")

            return request
        }

        public enum Key: String {
            case userId = "user_id"
            case domain = "domain"
        }

        public enum HeaderKey: String {
            case cookie = "Cookie"
        }
    }
}
