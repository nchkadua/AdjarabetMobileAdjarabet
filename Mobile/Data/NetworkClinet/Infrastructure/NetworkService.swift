//
//  NetworkService.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/7/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public typealias NetworkServiceResponseData = (data: Data?, headerFields: [AnyHashable: Any])

public protocol NetworkService {
    @discardableResult
    func request(request: URLRequest, completion: @escaping (Result<NetworkServiceResponseData, NetworkError>) -> Void) -> Cancellable
}

public enum NetworkError: Error {
    case errorStatusCode(statusCode: Int)
    case notConnected
    case cancelled
    case requestError(Error?)
}

public extension NetworkError {
    var isNotFoundError: Bool { return hasStatusCode(404) }

    func hasStatusCode(_ codeError: Int) -> Bool {
        switch self {
        case let .errorStatusCode(code):
            return code == codeError
        default: return false
        }
    }
}

extension URLSessionTask: Cancellable { }

public class DefaultNetworkService {
    private let logger: NetworkErrorLogger

    public init(logger: NetworkErrorLogger = DefaultNetworkErrorLogger()) {
        self.logger = logger
    }
}

extension DefaultNetworkService: NetworkService {
    public func request(request: URLRequest, completion: @escaping (Result<NetworkServiceResponseData, NetworkError>) -> Void) -> Cancellable {
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, requestError in
            var error: NetworkError
            if let requestError = requestError {
                if let response = response as? HTTPURLResponse, (400..<600).contains(response.statusCode) {
                    error = .errorStatusCode(statusCode: response.statusCode)
                    self?.logger.log(statusCode: response.statusCode)
                } else if requestError._code == NSURLErrorNotConnectedToInternet {
                    error = .notConnected
                } else if requestError._code == NSURLErrorCancelled {
                    error = .cancelled
                } else {
                    error = .requestError(requestError)
                }
                self?.logger.log(error: requestError)

                completion(.failure(error))
            } else {
                self?.logger.log(responseData: data, response: response)

                let headerFields = (response as? HTTPURLResponse)?.allHeaderFields ?? [:]
                let responseData = NetworkServiceResponseData(data: nil, headerFields: headerFields)
                completion(.success(responseData))
            }
        }

        logger.log(request: request)

        return task
    }
}
