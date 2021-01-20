//
//  HttpRequestBuilderTests.swift
//  MobileTests
//
//  Created by Giorgi Kratsashvili on 12/30/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import XCTest
@testable import Mobile

class HttpRequestBuilderTests: XCTestCase {

    private var requestBuilder: HttpRequestBuilder { HttpRequestBuilderImpl.createInstance() }

    private let host: String = "https://www.example.com"
    private let path: String = "some/path"

    // MARK: Black Box Tests

    /* Test set(host:) */

    func testHost() {
        // when
        let request = requestBuilder
            .set(host: host)
            .set(method: HttpMethodPost())
            .build()

        // than
        XCTAssertEqual(request.url?.absoluteString, host)
    }

    /* Test set(path:) */
    func testPath() {
        // when
        let request = requestBuilder
            .set(host: host)
            .set(path: path)
            .set(method: HttpMethodGet())
            .build()

        // than
        XCTAssertEqual(request.url?.absoluteString, "\(host)/\(path)")
    }

    /* Test setHeader(key:, value:) */

    func testHeader() {

        let key = "X-Some-Header-Key"
        let value = "Some-Header-Value"

        // when
        let request = requestBuilder
            .set(host: host)
            .setHeader(key: key, value: value)
            .set(method: HttpMethodPost())
            .build()

        // than
        XCTAssertEqual(request.allHTTPHeaderFields?[key], value)
    }

    /* Test set(headers:) */

    func testHeaders() {

        let key1   = "X-Some-Header1-Key"
        let value1 = "Some-Header1-Value"

        let key2   = "X-Some-Header2-Key"
        let value2 = "Some-Header2-Value"

        let headers = [
            key1: value1,
            key2: value2
        ]

        // when
        let request = requestBuilder
            .set(host: host)
            .set(headers: headers)
            .set(method: HttpMethodGet())
            .build()

        // than
        XCTAssertEqual(request.allHTTPHeaderFields?[key1], value1)
        XCTAssertEqual(request.allHTTPHeaderFields?[key2], value2)
    }

    /* Test set(method:) */

    /// .post
    func testMethodPost() {
        // when
        let getRequest = requestBuilder
            .set(host: host)
            .set(method: HttpMethodPost())
            .build()

        // than
        XCTAssertEqual(getRequest.httpMethod, "POST")
    }

    /// .get
    func testMethodGet() {
        // when
        let postRequest = requestBuilder
            .set(host: host)
            .set(method: HttpMethodGet())
            .build()

        // than
        XCTAssertEqual(postRequest.httpMethod, "GET")
    }

    /* Test set(contentType:) and set(body:) */

    /// .urlEncoded
    func testContentTypeUrlEncoded() {

        let key1 = "Key1"
        let val1 = "Val1"

        let key2 = "Key2"
        let val2 = "Val2"

        // when
        let request = requestBuilder
            .set(host: host)
            .set(method: HttpMethodPost())
            .set(contentType: ContentTypeUrlEncoded())
            .setBody(key: key1, value: val1)
            .set(body: [key2: val2])
            .build()

        // than
        XCTAssertEqual(request.allHTTPHeaderFields?["Content-Type"], "application/x-www-form-urlencoded")

        let expected1 = "\(key1)=\(val1)&\(key2)=\(val2)"
        let expected2 = "\(key2)=\(val2)&\(key1)=\(val1)"

        let actual = String(decoding: request.httpBody ?? .init(), as: UTF8.self)

        XCTAssert(actual == expected1 || actual == expected2)
    }

    /// .json
    func testContentTypeJson() {

        let jsonObj: [String: Any] = [
            "key1": "value1",
            "key2": []
        ]

        // when
        let request = requestBuilder
            .set(host: host)
            .set(method: HttpMethodPost())
            .set(contentType: ContentTypeJson())
            .setBody(json: jsonObj)
            .build()

        // than
        XCTAssertEqual(request.allHTTPHeaderFields?["Content-Type"], "application/json")

        let expected1 = "{\"key1\":\"value1\",\"key2\":[]}"
        let expected2 = "{\"key2\":[],\"key1\":\"value1\"}"

        let actual = String(decoding: request.httpBody ?? .init(), as: UTF8.self)

        XCTAssert(actual == expected1 || actual == expected2)
    }

    /// .raw
    func testContentTypeRaw() {
        let stringData = "Some Raw Data"

        // when
        let request = requestBuilder
            .set(host: host)
            .set(method: HttpMethodPost())
            .set(contentType: ContentTypeRaw())
            .setBody(raw: Data(stringData.utf8))
            .build()

        // than
        XCTAssertEqual(request.allHTTPHeaderFields?["Content-Type"], "text/plain")

        let expected = stringData
        let actual   = String(decoding: request.httpBody ?? .init(), as: UTF8.self)
        XCTAssertEqual(expected, actual)
    }
}
