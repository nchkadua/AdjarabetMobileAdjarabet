//
//  AdjarabetMobileClientRequestBuilder.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/30/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class AdjarabetMobileClientRequestBuilder: Builder {
    @Inject public var languageStorage: LanguageStorage

    public typealias Buildable = URLRequest

    private var url: URL
    private var params: [Key: Any] = [:]
    private var sessionId: String?

    public init(url: URL = AdjarabetEndpoints.mobileAPIUrl) {
        self.url = url
    }

    public func set(method: AdjarabetCoreClient.Method) -> Self {
        url.appendPathComponent(method.rawValue)
        return self
    }

    public func set(sessionId: String?, page: Int, numberOfItems: Int, term: String? = nil) -> Self {
        self.sessionId = sessionId
        params.addIfNotNil(key: .page, value: page)
        params.addIfNotNil(key: .propousedNumberOfItems, value: numberOfItems)
        params.addIfNotNil(key: .term, value: term)
        return self
    }

    public func build() -> URLRequest {
        let message = makeRequstMessage(sessionId: sessionId, params: params)
        let httpBody = try? JSONSerialization.data(withJSONObject: message)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = httpBody

        return request
    }

    public enum Key: String {
        case params
        case page
        case propousedNumberOfItems
        case term
        case platform
        case appVersion
        case languageCode
        case sessionId
    }

    private func makeRequstMessage(sessionId: String?, params: [Key: Any]) -> [String: Any] {
        var message: [Key: Any] = [
            .params: params,
            .platform: 0, // 0 indicates iOS
            .languageCode: languageStorage.currentLanguage.localizableIdentifier
        ]

        message.addIfNotNil(key: .appVersion, value: Bundle.main.fullVersion)
        message.addIfNotNil(key: .sessionId, value: sessionId)

        return Dictionary(uniqueKeysWithValues: message.map { ($0.key.rawValue, $0.value) })
    }
}
