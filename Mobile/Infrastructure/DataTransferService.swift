//
//  DataTransferService.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/7/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public enum DataTransferError: Error {
    case noResponse
    case parsingJSONFailure(Error)
    case networkFailure(NetworkError)
}

public protocol DataTransferService {
    @discardableResult
    func performTask<T: HeaderProvidingCodableType>(request: URLRequest, respondOnQueue: DispatchQueue, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable
    @discardableResult
    func performTask<T: Decodable>(request: URLRequest, respondOnQueue: DispatchQueue, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable
}

public class DefaultDataTransferService {
    @Inject private var networkService: NetworkService
}

extension DefaultDataTransferService: DataTransferService {
    public func performTask<T>(request: URLRequest, respondOnQueue: DispatchQueue, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable where T: HeaderProvidingCodableType {
        let task = self.networkService.request(request: request) { result in
            switch result {
            case .success(let response):
                guard let data = response.data else {
                    respondOnQueue.async { completion(Result.failure(DataTransferError.noResponse)) }
                    return
                }
                do {
                    // continue parsing if the status code is success
                    try T.validate(data: data)

                    let decoder = JSONDecoder()
                    let decoded = try decoder.decode(T.T.self, from: data)
                    let decodedHeader = try T.H(headers: response.headerFields)

                    let result = T(codable: decoded, header: decodedHeader)
                    respondOnQueue.async { completion(.success(result)) }
                } catch {
                    respondOnQueue.async { completion(Result.failure(DataTransferError.parsingJSONFailure(error))) }
                }
            case .failure(let error):
                respondOnQueue.async { completion(Result.failure(DataTransferError.networkFailure(error))) }
            }
        }

        return task
    }

    public func performTask<T>(request: URLRequest, respondOnQueue: DispatchQueue, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable where T: Decodable {
        let task = self.networkService.request(request: request) { result in
            switch result {
            case .success(let response):
                guard let data = response.data else {
                    respondOnQueue.async { completion(Result.failure(DataTransferError.noResponse)) }
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(T.self, from: data)
                    respondOnQueue.async { completion(.success(result)) }
                } catch {
                    respondOnQueue.async { completion(Result.failure(DataTransferError.parsingJSONFailure(error))) }
                }
            case .failure(let error):
                respondOnQueue.async { completion(Result.failure(DataTransferError.networkFailure(error))) }
            }
        }

        return task
    }
}
