//
//  DataTransferService.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/7/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public enum DataTransferError: Error {
    case responseNotFound
    case parsingJSONFailure(Error)
    case networkFailure(NetworkError)
}

public protocol DataTransferResponse {
    associatedtype Header: HeaderProtocol = DataTransferResponseDefaultHeader
    associatedtype Body: Codable
    associatedtype Entity
    /**
     Every Response Model **MUST** have functionallity of
     converting to Domain Model.
     P. S.
     Also you can pre-process header and body before returning Entity.
     */
    static func entity(header: Header, body: Body) -> Entity
}

public struct DataTransferResponseDefaultHeader: HeaderProtocol {
    public init(headers: [AnyHashable: Any]?) throws { }
}

public protocol DataTransferService {
    @discardableResult
    func performTask<Response: DataTransferResponse>(
        expecting: Response.Type,
        request: URLRequest,
        respondOnQueue: DispatchQueue,
        completion: @escaping (Result<Response.Entity, Error>) -> Void
    ) -> Cancellable
    // TODO: delete lower functions
    @discardableResult
    func performTask<T: HeaderProvidingCodableType>(request: URLRequest, respondOnQueue: DispatchQueue, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable
    @discardableResult
    func performTask<T: Decodable>(request: URLRequest, respondOnQueue: DispatchQueue, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable
}

public class DefaultDataTransferService {
    @Inject private var networkService: NetworkService
}

extension DefaultDataTransferService: DataTransferService {
    public func performTask<Response: DataTransferResponse>(
        expecting: Response.Type,
        request: URLRequest,
        respondOnQueue: DispatchQueue,
        completion: @escaping (Result<Response.Entity, Error>) -> Void) -> Cancellable {
        let task = self.networkService.request(request: request) { result in
            switch result {
            case .success(let response):
                guard let data = response.data else {
                    respondOnQueue.async { completion(.failure(DataTransferError.responseNotFound)) }
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let body    = try decoder.decode(Response.Body.self, from: data)
                    let header  = try Response.Header(headers: response.headerFields)
                    let result  = Response.entity(header: header, body: body)
                    respondOnQueue.async { completion(.success(result)) }
                } catch {
                    respondOnQueue.async { completion(.failure(DataTransferError.parsingJSONFailure(error))) }
                }
            case .failure(let error):
                respondOnQueue.async { completion(.failure(DataTransferError.networkFailure(error))) }
            }
        }
        return task
    }

    public func performTask<T>(request: URLRequest, respondOnQueue: DispatchQueue, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable where T: HeaderProvidingCodableType {
        let task = self.networkService.request(request: request) { result in
            switch result {
            case .success(let response):
                guard let data = response.data else {
                    respondOnQueue.async { completion(.failure(DataTransferError.responseNotFound)) }
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let decoded = try decoder.decode(T.T.self, from: data)
                    let decodedHeader = try T.H(headers: response.headerFields)

                    let result = T(codable: decoded, header: decodedHeader)
                    respondOnQueue.async { completion(.success(result)) }
                } catch {
                    respondOnQueue.async { completion(.failure(DataTransferError.parsingJSONFailure(error))) }
                }
            case .failure(let error):
                respondOnQueue.async { completion(.failure(DataTransferError.networkFailure(error))) }
            }
        }

        return task
    }

    public func performTask<T>(request: URLRequest, respondOnQueue: DispatchQueue, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable where T: Decodable {
        let task = self.networkService.request(request: request) { result in
            switch result {
            case .success(let response):
                guard let data = response.data else {
                    respondOnQueue.async { completion(.failure(DataTransferError.responseNotFound)) }
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(T.self, from: data)
                    respondOnQueue.async { completion(.success(result)) }
                } catch {
                    respondOnQueue.async { completion(.failure(DataTransferError.parsingJSONFailure(error))) }
                }
            case .failure(let error):
                respondOnQueue.async { completion(.failure(DataTransferError.networkFailure(error))) }
            }
        }

        return task
    }
}
