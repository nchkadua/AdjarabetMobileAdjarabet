//
//  AdjarabetCoreClient.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public extension AdjarabetCoreClient {
    var standartRequestBuilder: AdjarabetCoreRequestBuilder {
        return AdjarabetCoreRequestBuilder(url: baseUrl)
    }

    class AdjarabetCoreRequestBuilder: Builder {
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
            queryItems.append(URLQueryItem(name: Key.req.rawValue, value: method.rawValue))
            return self
        }

        public func set(username: String, password: String, channel: Int) -> Self {
            queryItems.append(URLQueryItem(name: Key.userIdentifier.rawValue, value: username))
            queryItems.append(URLQueryItem(name: Key.password.rawValue, value: password))
            queryItems.append(URLQueryItem(name: Key.otpDeliveryChannel.rawValue, value: "\(channel)"))
            return self
        }

        public func set(userId: Int, currencyId: Int, isSingle: Int) -> Self {
            queryItems.append(URLQueryItem(name: Key.userId.rawValue, value: "\(userId)"))
            queryItems.append(URLQueryItem(name: Key.currencyId.rawValue, value: "\(currencyId)"))
            queryItems.append(URLQueryItem(name: Key.isSingle.rawValue, value: "\(isSingle)"))
            return self
        }

        public func set(username: String, channel: Int) -> Self {
            queryItems.append(URLQueryItem(name: Key.userIdentifier.rawValue, value: username))
            queryItems.append(URLQueryItem(name: Key.channelType.rawValue, value: "\(channel)"))
            return self
        }

        public func set(userId: Int) -> Self {
            queryItems.append(URLQueryItem(name: Key.userId.rawValue, value: "\(userId)"))
            return self
        }

        public func set(username: String, code: String, loginType: LoginType) -> Self {
            queryItems.append(URLQueryItem(name: Key.userIdentifier.rawValue, value: username))
            queryItems.append(URLQueryItem(name: Key.otp.rawValue, value: code))
            queryItems.append(URLQueryItem(name: Key.loginType.rawValue, value: loginType.rawValue))
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
            case userIdentifier
            case password
            case req
            case otpDeliveryChannel
            case userId = "userID"
            case currencyId = "currencyID"
            case isSingle
            case channelType
            case otp
            case loginType
        }

        public enum HeaderKey: String {
            case cookie = "Cookie"
        }
    }
}

public protocol Builder {
    associatedtype Buildable

    func build() -> Buildable
}
