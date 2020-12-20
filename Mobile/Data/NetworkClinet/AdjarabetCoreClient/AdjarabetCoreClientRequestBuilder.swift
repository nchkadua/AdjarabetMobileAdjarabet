//
//  AdjarabetCoreClientRequestBuilder.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class AdjarabetCoreClientRequestBuilder: Builder {
    public typealias Buildable = URLRequest

    @Inject private var requestBuilder: HttpRequestBuilder
    @Inject private var userAgentProvider: UserAgentProvider

    private var url: URL
    private var queryItems: [String: String] = [:]
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
        queryItems[Key.req.rawValue] = method.rawValue
        return self
    }

    public func set(username: String, password: String, channel: Int) -> Self {
        queryItems[Key.userIdentifier.rawValue] = username
        queryItems[Key.password.rawValue] = password
        queryItems[Key.otpDeliveryChannel.rawValue] = "\(channel)"
        return self
    }

    public func set(userId: Int, currencyId: Int, isSingle: Int) -> Self {
        queryItems[Key.userId.rawValue] = "\(userId)"
        queryItems[Key.currencyId.rawValue] = "\(currencyId)"
        queryItems[Key.isSingle.rawValue] = "\(isSingle)"
        return self
    }

    public func set(username: String, channel: Int) -> Self {
        queryItems[Key.userIdentifier.rawValue] = username
        queryItems[Key.channelType.rawValue] = "\(channel)"
        return self
    }

    public func set(userId: Int) -> Self {
        queryItems[Key.userId.rawValue] = "\(userId)"
        return self
    }

    public func set(username: String, code: String, loginType: LoginType) -> Self {
        queryItems[Key.userIdentifier.rawValue] = username
        queryItems[Key.otp.rawValue] = code
        queryItems[Key.loginType.rawValue] = loginType.rawValue
        return self
    }

    public func setHeader(key: HeaderKey, value: String) -> Self {
        headers[key.rawValue] = value
        return self
    }

    public func build() -> URLRequest {
        requestBuilder
            .set(host: url.absoluteString)
            .set(path: "")
            .set(headers: headers)
            .setHeader(key: "User-Agent", value: userAgentProvider.userAgent)
            .set(method: HttpMethodPost())
            .set(contentType: ContentTypeUrlEncoded())
            .set(body: queryItems)
            .build()
    }

    // MARK: Transaction History

    public func set(fromDate: String, toDate: String) -> Self {
        queryItems[Key.fromDate.rawValue] = fromDate
        queryItems[Key.toDate.rawValue] = toDate
        return self
    }

    public func set(transactionType: Int?) -> Self {
        if let transactionType = transactionType {
            queryItems[Key.transactionType.rawValue] = "\(transactionType)"
        }
        return self
    }

    public func set(maxResult: Int) -> Self {
        queryItems[Key.maxResult.rawValue] = "\(maxResult)"
        return self
    }

    public func set(pageIndex: Int) -> Self {
        queryItems[Key.pageIndex.rawValue] = "\(pageIndex)"
        return self
    }

    public func set(providerType: Int) -> Self {
        queryItems[Key.providerType.rawValue] = "\(providerType)"
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
