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
public typealias HostSetterReturnType = PathSetterHttpRequestBuilder

public protocol HostSetterHttpRequestBuilder {
    func set(host: String) -> HostSetterReturnType
}

/* Path */
public typealias PathSetterReturnType = HeaderSetterHttpRequestBuilder &
                                        HttpMethodSetterHttpRequestBuilder

public protocol PathSetterHttpRequestBuilder {
    func set(path: String) -> PathSetterReturnType
}

/* Headers */
public typealias HeaderSetterReturnType = HeaderSetterHttpRequestBuilder &
                                          HttpMethodSetterHttpRequestBuilder

public protocol HeaderSetterHttpRequestBuilder {
    func setHeader(key: String, value: String) -> HeaderSetterReturnType
}

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
    case raw
    /**
     TO DO: Add cases (none, graphql ...)
     */
    var value: String {
        switch self {
        case .urlEncoded: return "application/x-www-form-urlencoded"
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

/// .raw
public struct ContentTypeRaw: ContentTypeInfo {
    public let contentType: ContentType = .raw
    public typealias NextProtocol = RawContentSetterHttpRequestBuilder &
                                    UrlRequestBuilderHttpRequestBuilder
}

/* Content */
// Url Encoded Content
public typealias UrlEncodedContentSetterReturnType = UrlEncodedContentSetterHttpRequestBuilder &
                                                     UrlRequestBuilderHttpRequestBuilder

public protocol UrlEncodedContentSetterHttpRequestBuilder {
    func setBody(key: String, value: String) -> UrlEncodedContentSetterReturnType
}

// Raw Content
public typealias RawContentSetterReturnType = UrlRequestBuilderHttpRequestBuilder

public protocol RawContentSetterHttpRequestBuilder {
    func setBody(raw: String) -> RawContentSetterReturnType
}

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
                                                RawContentSetterHttpRequestBuilder &
                                                UrlRequestBuilderHttpRequestBuilder

/**
 HttpRequestBuilder Implementation
 */
public class HttpRequestBuilderImpl: HttpRequestBuilderProtocols {
    private var components = URLComponents()
    private var request = URLRequest(url: URL(string: "")!) // url will be updated later

    public init() { }

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
        request.url = components.url
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

    public func setBody(key: String, value: String) -> UrlEncodedContentSetterReturnType {
        return self
    }

    public func setBody(raw: String) -> RawContentSetterReturnType {
        return self
    }

    public func build() -> URLRequest {
        return URLRequest(url: URL(string: "")!)
    }
}
