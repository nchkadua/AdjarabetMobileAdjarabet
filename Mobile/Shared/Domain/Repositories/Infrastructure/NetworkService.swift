//
//  NetworkService.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/7/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public typealias NetworkServiceResponse = (data: Data?, headerFields: [AnyHashable: Any])

public protocol NetworkService {
    @discardableResult
    func request(request: URLRequest, completion: @escaping (Result<NetworkServiceResponse, NetworkError>) -> Void) -> Cancellable
}

public enum NetworkError: Error {
    case errorStatusCode(statusCode: Int)
    case notConnected
    case cancelled
    case requestError(Error?)
}

extension URLSessionTask: Cancellable { }

public class DefaultNetworkService {
    @Inject private var logger: NetworkErrorLogger
}

extension DefaultNetworkService: NetworkService {
    public func request(request: URLRequest, completion: @escaping (Result<NetworkServiceResponse, NetworkError>) -> Void) -> Cancellable {
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
                let responseData = NetworkServiceResponse(data: data, headerFields: headerFields)
                completion(.success(responseData))
            }
        }

        logger.log(request: request)

        task.resume()

        return task
    }
}
