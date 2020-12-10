//
//  AdjarabetCoreClientRequestBuilder.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class AdjarabetCoreClientRequestBuilder: Builder {
    public typealias Buildable = URLRequest

    @Inject private var userAgentProvider: UserAgentProvider

    private var url: URL
    private var queryItems: [URLQueryItem] = []
    private var headers = [
        "Content-Type": "application/x-www-form-urlencoded",
        "Origin": AppConstant.coreOriginDomain,
        "Referer": AppConstant.coreOriginDomain,
        "X-Requested-With": "XMLHttpRequest"
    ]

    public init(url: URL = AdjarabetEndpoints.coreAPIUrl) {
        self.url = url
    }

    public func set(method: AdjarabetCoreClient.Method) -> Self {
        queryItems.append(.init(key: .req, value: method.rawValue))
        return self
    }

    public func set(username: String, password: String, channel: Int) -> Self {
        queryItems.append(.init(key: .userIdentifier, value: username))
        queryItems.append(.init(key: .password, value: password))
        queryItems.append(.init(key: .otpDeliveryChannel, value: "\(channel)"))
        return self
    }

    public func set(userId: Int, currencyId: Int, isSingle: Int) -> Self {
        queryItems.append(.init(key: .userId, value: "\(userId)"))
        queryItems.append(.init(key: .currencyId, value: "\(currencyId)"))
        queryItems.append(.init(key: .isSingle, value: "\(isSingle)"))
        return self
    }

    public func set(username: String, channel: Int) -> Self {
        queryItems.append(.init(key: .userIdentifier, value: username))
        queryItems.append(.init(key: .channelType, value: "\(channel)"))
        return self
    }

    public func set(userId: Int) -> Self {
        queryItems.append(.init(key: .userId, value: "\(userId)"))
        return self
    }

    public func set(username: String, code: String, loginType: LoginType) -> Self {
        queryItems.append(.init(key: .userIdentifier, value: username))
        queryItems.append(.init(key: .otp, value: code))
        queryItems.append(.init(key: .loginType, value: loginType.rawValue))
        return self
    }

    public func setHeader(key: HeaderKey, value: String) -> Self {
        headers[key.rawValue] = value
        return self
    }

    public func build() -> URLRequest {
        headers["User-Agent"] = userAgentProvider.userAgent

        var component = URLComponents(url: url, resolvingAgainstBaseURL: false)
        component?.queryItems = queryItems

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = component?.query?.data(using: String.Encoding.utf8)

        return request
    }

    // MARK: Transaction History

    public func set(fromDate: String, toDate: String) -> Self {
        queryItems.append(.init(key: .fromDate, value: fromDate))
        queryItems.append(.init(key: .toDate, value: toDate))
        return self
    }

    public func set(transactionType: Int?) -> Self {
        if let transactionType = transactionType {
            queryItems.append(.init(key: .transactionType, value: "\(transactionType)"))
        }
        return self
    }

    public func set(maxResult: Int) -> Self {
        queryItems.append(.init(key: .maxResult, value: "\(maxResult)"))
        return self
    }

    public func set(pageIndex: Int) -> Self {
        queryItems.append(.init(key: .pageIndex, value: "\(pageIndex)"))
        return self
    }

    public func set(providerType: Int) -> Self {
        queryItems.append(.init(key: .pageIndex, value: "\(providerType)"))
        return self
    }

    // MARK: Keys

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
        case fromDate
        case toDate
        case transactionType = "trType"
        case providerType
        case maxResult
        case pageIndex
    }

    public enum HeaderKey: String {
        case cookie = "Cookie"
    }
}

public extension URLQueryItem {
    init(key: AdjarabetCoreClientRequestBuilder.Key, value: String?) {
        self.init(name: key.rawValue, value: value)
    }
}
