//
//  HttpRequestBuilder.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 12/20/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

/**

 URL --- URI --- Headers? --- Method --- GET --- Build
                           '--- POST --- Content Type? --- Content? --- Build

 */

// Initial interface known to user
public protocol HttpRequestBuilder: UrlSetterHttpRequestBuilder { }

// Interfaces known to user

/* URL */
public typealias UrlSetterReturnType = UriSetterHttpRequestBuilder

public protocol UrlSetterHttpRequestBuilder {
    func set(url: URL) -> UrlSetterReturnType
    func set(url: String) -> UrlSetterReturnType
}

/* URI */
public typealias UriSetterReturnType = HeaderSetterHttpRequestBuilder &
                                       HttpMethodSetterHttpRequestBuilder

public protocol UriSetterHttpRequestBuilder {
    func set(uri: String) -> UriSetterReturnType
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
    case get
    case post
    /**
     TO DO: Add cases (put, delete ...)
     */
    // add description if needed ...
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
    // add description if needed ...
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
                                                UrlSetterHttpRequestBuilder &
                                                UriSetterHttpRequestBuilder &
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
    public init() { }

    public static func createInstance() -> HttpRequestBuilder {
        return HttpRequestBuilderImpl()
    }

    // protocol implementations

    public func set(url: URL) -> UrlSetterReturnType {
        return self
    }

    public func set(url: String) -> UrlSetterReturnType {
        return self
    }

    public func set(uri: String) -> UriSetterReturnType {
        return self
    }

    public func setHeader(key: String, value: String) -> HeaderSetterReturnType {
        guard key != "Content-Type"
        else {
            fatalError("Specify Content-Type using set(contentType:) method")
        }

        return self
    }

    public func set<T: HttpMethodTypeInfo>(method info: T) -> T.NextProtocol {
        guard let self = self as? T.NextProtocol
        else {
            fatalError("Invalid call of set(method:), you must use only protocol specified 'HttpMethodTypeInfo' implementations")
        }

        _ = info.method
        return self
    }

    public func set<T: ContentTypeInfo>(contentType info: T) -> T.NextProtocol {
        guard let self = self as? T.NextProtocol
        else {
            fatalError("Invalid call of set(contentType:), you must use only protocol specified 'ContentTypeInfo' implementations")
        }

        _ = info.contentType
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
