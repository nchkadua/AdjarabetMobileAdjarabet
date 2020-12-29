//
//  MobileRequestBuilder.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/30/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class MobileRequestBuilder {
    @Inject private var requestBuilder: HttpRequestBuilder
    @Inject public var languageStorage: LanguageStorage

    private var host = Bundle.main.mobileApiUrl
    private var path: String?

    private var body: [String: Any] = [:]

    public func set(method: Method) -> Self {
        path = method.rawValue
        return self
    }

    public func setBody(key: BodyKey, value: Any) -> Self {
        body[key.rawValue] = value
        return self
    }

    public func setBody(key: String, value: Any) -> Self {
        body[key] = value
        return self
    }

    public func build() -> URLRequest {
        guard let path = path else {
            fatalError("Call set(method:) to initialize 'path' variable")
        }
        return requestBuilder
            .set(host: host)
            .set(path: path)
            .set(method: HttpMethodPost())
            .set(contentType: ContentTypeJson())
            .setBody(json: requstMessage)
            .build()
    }

    public enum Method: String {
        case games = "games"
        case recentlyPlayed = "games/recentlyPlayed"
    }

    public enum BodyKey: String {
        case params
        case page
        case propousedNumberOfItems
        case term
        case platform
        case appVersion
        case languageCode
        case sessionId
        case userId
        case osVersion
        case deviceName
    }

    // Helpers

    var requstMessage: [String: Any] {
        var message: [BodyKey: Any] = [
            .params: body,
            .platform: 0, // 0 indicates iOS
            .languageCode: languageStorage.currentLanguage.localizableIdentifier,
            .osVersion: UIDevice.current.systemVersion,
            .deviceName: Device.shared.current.name.rawValue
        ]
        message.addIfNotNil(key: .appVersion, value: Bundle.main.fullVersion)
        return message.toStringKeys()
    }
}

// MARK: - Bundle coreApiUrl
fileprivate extension Bundle {
    var mobileApiUrl: String {
        return stringValue(forKey: "MOBILE_API_URL")
    }
}

// MARK: - Dictionary toStringKeys()
fileprivate extension Dictionary where Key: RawRepresentable, Key.RawValue == String, Value == Any {
    func toStringKeys() -> [String: Value] {
        [String: Value](uniqueKeysWithValues: self.map {
            ($0.key.rawValue, $0.value)
        })
    }
}
