//
//  HttpRequestBuilder.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 12/20/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

/**

 Host --- Path --- Headers? --- Method --- GET --- Build
                            '--- POST --- Content Type? --- Content? --- Build

 */

// Initial interface known to user
public protocol HttpRequestBuilder: HostSetterHttpRequestBuilder { }

// Interfaces known to user

/* Host */
public protocol HostSetterHttpRequestBuilder {
    func set(host: String) -> HostSetterReturnType
}

public typealias HostSetterReturnType = PathSetterHttpRequestBuilder &
                                        PathSetterReturnType // jump over path setting if decired

/* Path */
public protocol PathSetterHttpRequestBuilder {
    func set(path: String) -> PathSetterReturnType
}

public typealias PathSetterReturnType = HeaderSetterHttpRequestBuilder &
                                        HttpMethodSetterHttpRequestBuilder

/* Headers */
public protocol HeaderSetterHttpRequestBuilder {
    func set(headers: [String: String]) -> HeaderSetterReturnType
    func setHeader(key: String, value: String) -> HeaderSetterReturnType
}

public typealias HeaderSetterReturnType = HeaderSetterHttpRequestBuilder &
                                          HttpMethodSetterHttpRequestBuilder

/* Method */
public protocol HttpMethodSetterHttpRequestBuilder {
    func set<T: HttpMethodTypeInfo>(method info: T) -> T.NextProtocol
}

/// Method Type associated description
public protocol HttpMethodTypeInfo {
    var method: HttpMethodType { get }
    associatedtype NextProtocol
}

/// Method Types
public enum HttpMethodType {
    case post
    case get
    /**
     TO DO: Add cases (put, delete ...)
     */
    var value: String {
        switch self {
        case .post: return "POST"
        case .get:  return "GET"
        }
    }
}

/// .get
public struct HttpMethodGet: HttpMethodTypeInfo {
    public let method: HttpMethodType = .get
    public typealias NextProtocol = UrlRequestBuilderHttpRequestBuilder
}

/// .post
public struct HttpMethodPost: HttpMethodTypeInfo {
    public let method: HttpMethodType = .post
    public typealias NextProtocol = ContentTypeSetterHttpRequestBuilder &
                                    UrlRequestBuilderHttpRequestBuilder
}

/* Content Type */
public protocol ContentTypeSetterHttpRequestBuilder {
    func set<T: ContentTypeInfo>(contentType info: T) -> T.NextProtocol
}

/// Content Type associated description
public protocol ContentTypeInfo {
    var contentType: ContentType { get }
    associatedtype NextProtocol
}

/// Method Types
public enum ContentType {
    case urlEncoded
    case json
    case raw
    /**
     TO DO: Add cases (none, graphql ...)
     */
    var value: String {
        switch self {
        case .urlEncoded: return "application/x-www-form-urlencoded"
        case .json:       return "application/json"
        case .raw:        return "text/plain"
        }
    }
}

/// .urlEncoded
public struct ContentTypeUrlEncoded: ContentTypeInfo {
    public let contentType: ContentType = .urlEncoded
    public typealias NextProtocol = UrlEncodedContentSetterHttpRequestBuilder &
                                    UrlRequestBuilderHttpRequestBuilder
}

/// .json
public struct ContentTypeJson: ContentTypeInfo {
    public let contentType: ContentType = .json
    public typealias NextProtocol = JsonContentSetterHttpRequestBuilder &
                                    UrlRequestBuilderHttpRequestBuilder
}

/// .raw
public struct ContentTypeRaw: ContentTypeInfo {
    public let contentType: ContentType = .raw
    public typealias NextProtocol = RawContentSetterHttpRequestBuilder &
                                    UrlRequestBuilderHttpRequestBuilder
}

/* Content */
// Url Encoded Content
public protocol UrlEncodedContentSetterHttpRequestBuilder {
    func set(body: [String: String]) -> UrlEncodedContentSetterReturnType
    func setBody(key: String, value: String) -> UrlEncodedContentSetterReturnType
}

public typealias UrlEncodedContentSetterReturnType = UrlEncodedContentSetterHttpRequestBuilder &
                                                     UrlRequestBuilderHttpRequestBuilder

// Json Content
public protocol JsonContentSetterHttpRequestBuilder {
    func setBody(json data: Any) -> JsonContentSetterReturnType
}

public typealias JsonContentSetterReturnType = UrlRequestBuilderHttpRequestBuilder

// Raw Content
public protocol RawContentSetterHttpRequestBuilder {
    func setBody(raw data: Data) -> RawContentSetterReturnType
}

public typealias RawContentSetterReturnType = UrlRequestBuilderHttpRequestBuilder

/* Build */
public protocol UrlRequestBuilderHttpRequestBuilder {
    func build() -> URLRequest
}

private typealias HttpRequestBuilderProtocols = HttpRequestBuilder &
                                                HostSetterHttpRequestBuilder &
                                                PathSetterHttpRequestBuilder &
                                                HeaderSetterHttpRequestBuilder &
                                                HttpMethodSetterHttpRequestBuilder &
                                                ContentTypeSetterHttpRequestBuilder &
                                                UrlEncodedContentSetterHttpRequestBuilder &
                                                JsonContentSetterHttpRequestBuilder &
                                                RawContentSetterHttpRequestBuilder &
                                                UrlRequestBuilderHttpRequestBuilder

/**
 HttpRequestBuilder Implementation
 */
public class HttpRequestBuilderImpl: HttpRequestBuilderProtocols {
    private lazy var components: URLComponents = {
        var components = URLComponents() // default initialization
        components.queryItems = []
        components.path = ""
        return components
    }()

    private lazy var request: URLRequest = {
        // NOTE: components.host and components.path must be set
        var url = URL(string: components.host!)!
        if !components.path.isEmpty {
            url = url.appendingPathComponent(components.path)
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpBody = nil
        return urlRequest
    }()

    private init() { }

    public static func createInstance() -> HttpRequestBuilder {
        return HttpRequestBuilderImpl()
    }

    // protocol implementations

    public func set(host: String) -> HostSetterReturnType {
        components.host = host
        return self
    }

    public func set(path: String) -> PathSetterReturnType {
        components.path = path
        return self
    }

    public func set(headers: [String: String]) -> HeaderSetterReturnType {
        headers.forEach { key, value in
            _ = setHeader(key: key, value: value)
        }
        return self
    }

    public func setHeader(key: String, value: String) -> HeaderSetterReturnType {
        guard key != "Content-Type"
        else {
            fatalError("Specify Content-Type using set(contentType:) method")
        }
        request.setValue(value, forHTTPHeaderField: key)
        return self
    }

    public func set<T: HttpMethodTypeInfo>(method info: T) -> T.NextProtocol {
        guard let self = self as? T.NextProtocol
        else {
            fatalError("Invalid call of set(method:), you must use only protocol specified 'HttpMethodTypeInfo' implementations")
        }
        request.httpMethod = info.method.value
        return self
    }

    public func set<T: ContentTypeInfo>(contentType info: T) -> T.NextProtocol {
        guard let self = self as? T.NextProtocol
        else {
            fatalError("Invalid call of set(contentType:), you must use only protocol specified 'ContentTypeInfo' implementations")
        }
        request.setValue(info.contentType.value, forHTTPHeaderField: "Content-Type")
        return self
    }

    public func set(body: [String: String]) -> UrlEncodedContentSetterReturnType {
        body.forEach { key, value in
            _ = setBody(key: key, value: value)
        }
        return self
    }

    public func setBody(key: String, value: String) -> UrlEncodedContentSetterReturnType {
        components.queryItems?.append(.init(name: key, value: value))
        return self
    }

    public func setBody(json obj: Any) -> JsonContentSetterReturnType {
        do {
            let data = try JSONSerialization.data(withJSONObject: obj)
            request.httpBody = data
            return self
        } catch {
         // fatalError("Invalid JSON Object passed")
            return self
        }
    }

    public func setBody(raw data: Data) -> RawContentSetterReturnType {
        request.httpBody = data
        return self
    }

    public func build() -> URLRequest {
        // if Content-Type is set to application/x-www-form-urlencoded (if not - text/plain)
        // we should fill httpBody
        if request.allHTTPHeaderFields?["Content-Type"] == ContentType.urlEncoded.value {
            request.httpBody = components.query?.data(using: String.Encoding.utf8)
        }

        #if DEBUG
        // Log Request before returning
        print("""



        HttpRequestBuilder
        Host:         \(components.host ?? "nil")
        Path:         \(components.path)
        URL:          \(String(describing: request.url))
        Method:       \(request.httpMethod ?? "nil")
        Headers: \(request.allHTTPHeaderFields as AnyObject)
        Content-Type: \(request.allHTTPHeaderFields?["Content-Type"] ?? "nil")
        Body:         \(String(decoding: request.httpBody ?? .init(), as: UTF8.self))



        """)
        #endif

        return request
    }
}
