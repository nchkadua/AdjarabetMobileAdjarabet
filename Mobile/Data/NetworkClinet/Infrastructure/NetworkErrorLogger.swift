//
//  NetworkErrorLogger.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/7/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol NetworkErrorLogger {
    func log(request: URLRequest)
    func log(responseData data: Data?, response: URLResponse?)
    func log(error: Error)
    func log(statusCode: Int)
}

public class DefaultNetworkErrorLogger {
}

extension DefaultNetworkErrorLogger: NetworkErrorLogger {
    public func log(request: URLRequest) {
        #if DEBUG
        print("-------------")
        print("request: \(request.url?.absoluteString ?? "")")
        print("headers: \(request.allHTTPHeaderFields ?? [:])")
        print("method: \(request.httpMethod ?? "")")
        if let httpBody = request.httpBody, let result = ((try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: AnyObject]) as [String: AnyObject]??) {
            print("body: \(String(describing: result))")
        }
        if let httpBody = request.httpBody, let resultString = String(data: httpBody, encoding: .utf8) {
            print("body: \(String(describing: resultString))")
        }
        #endif
    }

    public func log(responseData data: Data?, response: URLResponse?) {
        #if DEBUG
        let headerFields = (response as? HTTPURLResponse)?.allHeaderFields ?? [:]

        print("headerFields: \(headerFields)")

        guard let data = data, let responseData = String(data: data, encoding: .utf8) else {return}

        print("responseData: \(responseData)")
        #endif
    }

    public func log(error: Error) {
        #if DEBUG
        switch error {
        case DecodingError.dataCorrupted(let context):
            print(context)
        case DecodingError.keyNotFound(let key, let context):
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        case DecodingError.valueNotFound(let value, let context):
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        case DecodingError.typeMismatch(let type, let context):
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        default:
            print("error: \(error)")
        }
        #endif
    }

    public func log(statusCode: Int) {
        #if DEBUG
        print("status code: \(statusCode)")
        #endif
    }
}
