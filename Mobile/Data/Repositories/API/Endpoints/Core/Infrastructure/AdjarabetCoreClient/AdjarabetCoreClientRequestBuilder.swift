//
//  AdjarabetCoreClientRequestBuilder.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class AdjarabetCoreClientRequestBuilder {
    @Inject private var requestBuilder: HttpRequestBuilder
    @Inject private var userAgentProvider: UserAgentProvider

    // url
    private var url = Bundle.main.coreApiUrl

    // header key:values
    private lazy var headers = [
        "Origin": AppConstant.coreOriginDomain,
        "Referer": AppConstant.coreOriginDomain,
        "X-Requested-With": "XMLHttpRequest",
        "User-Agent": userAgentProvider.userAgent
    ]

    // body key:values
    private var body = [String: String]()

    public func setHeader(key: HeaderKey, value: String) -> Self {
        headers[key.rawValue] = value
        return self
    }

    public func setHeader(key: String, value: String) -> Self {
        headers[key] = value
        return self
    }

    public func set(key: BodyKey, value: String) -> Self {
        body[key.rawValue] = value
        return self
    }

    public func set(key: String, value: String) -> Self {
        body[key] = value
        return self
    }

    public func build() -> URLRequest {
        requestBuilder
            .set(host: url)
            .set(path: "")
            .set(headers: headers)
            .set(method: HttpMethodPost())
            .set(contentType: ContentTypeUrlEncoded())
            .set(body: body)
            .build()
    }

    public enum BodyKey: String {
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

    /* deprecated part */ // TODO: Delete

    @available(*, deprecated, message: "Please use set(key:, value:)")
    public func set(method: AdjarabetCoreClient.Method) -> Self {
        body[BodyKey.req.rawValue] = method.rawValue
        return self
    }

    @available(*, deprecated, message: "Please use set(key:, value:)")
    public func set(username: String, password: String, channel: Int) -> Self {
        body[BodyKey.userIdentifier.rawValue] = username
        body[BodyKey.password.rawValue] = password
        body[BodyKey.otpDeliveryChannel.rawValue] = "\(channel)"
        return self
    }

    @available(*, deprecated, message: "Please use set(key:, value:)")
    public func set(userId: Int, currencyId: Int, isSingle: Int) -> Self {
        body[BodyKey.userId.rawValue] = "\(userId)"
        body[BodyKey.currencyId.rawValue] = "\(currencyId)"
        body[BodyKey.isSingle.rawValue] = "\(isSingle)"
        return self
    }

    @available(*, deprecated, message: "Please use set(key:, value:)")
    public func set(username: String, channel: Int) -> Self {
        body[BodyKey.userIdentifier.rawValue] = username
        body[BodyKey.channelType.rawValue] = "\(channel)"
        return self
    }

    @available(*, deprecated, message: "Please use set(key:, value:)")
    public func set(userId: Int) -> Self {
        body[BodyKey.userId.rawValue] = "\(userId)"
        return self
    }

    @available(*, deprecated, message: "Please use set(key:, value:)")
    public func set(username: String, code: String, loginType: LoginType) -> Self {
        body[BodyKey.userIdentifier.rawValue] = username
        body[BodyKey.otp.rawValue] = code
        body[BodyKey.loginType.rawValue] = loginType.rawValue
        return self
    }

    @available(*, deprecated, message: "Please use set(key:, value:)")
    public func set(fromDate: String, toDate: String) -> Self {
        body[BodyKey.fromDate.rawValue] = fromDate
        body[BodyKey.toDate.rawValue] = toDate
        return self
    }

    @available(*, deprecated, message: "Please use set(key:, value:)")
    public func set(transactionType: Int?) -> Self {
        if let transactionType = transactionType {
            body[BodyKey.transactionType.rawValue] = "\(transactionType)"
        }
        return self
    }

    @available(*, deprecated, message: "Please use set(key:, value:)")
    public func set(maxResult: Int) -> Self {
        body[BodyKey.maxResult.rawValue] = "\(maxResult)"
        return self
    }

    @available(*, deprecated, message: "Please use set(key:, value:)")
    public func set(pageIndex: Int) -> Self {
        body[BodyKey.pageIndex.rawValue] = "\(pageIndex)"
        return self
    }

    @available(*, deprecated, message: "Please use set(key:, value:)")
    public func set(providerType: Int) -> Self {
        body[BodyKey.providerType.rawValue] = "\(providerType)"
        return self
    }
}

// MARK: - Bundle coreApiUrl
fileprivate extension Bundle {
    var coreApiUrl: String {
        return stringValue(forKey: "CORE_API_URL")
    }
}
