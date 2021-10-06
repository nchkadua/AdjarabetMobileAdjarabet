//
//  CoreRequestBuilder.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class CoreRequestBuilder {
    @Inject private var requestBuilder: HttpRequestBuilder
    @Inject private var userAgentProvider: UserAgentProvider

    // url
    private var host = Bundle.main.coreApiUrl

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

    public func setBody(key: BodyKey, value: String) -> Self {
        body[key.rawValue] = value
        return self
    }

    public func setBody(key: String, value: String) -> Self {
        body[key] = value
        return self
    }

    public func build() -> URLRequest {
        requestBuilder
            .set(host: host)
            .set(headers: headers)
            .set(method: HttpMethodPost())
            .set(contentType: ContentTypeUrlEncoded())
            .set(body: body)
            .build()
    }

    public enum HeaderKey: String {
        case cookie = "Cookie"
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
        case oldPassword
        case newPassword
		case limitType
    }
}

// MARK: - Bundle coreApiUrl
fileprivate extension Bundle {
    var coreApiUrl: String {
        return stringValue(forKey: "CORE_API_URL")
    }
}
