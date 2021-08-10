//
//  DataTransferService.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/7/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

enum DataTransferError: Error {
    case responseNotFound
    case parsingJSONFailure(Error)
    case networkFailure(NetworkError)
}

protocol DataTransferResponse {
    associatedtype Header: HeaderProtocol = DataTransferResponseDefaultHeader
    associatedtype Body: Codable
    associatedtype Entity
    /**
     Every Response Model **MUST** have functionallity of
     converting to Domain Model.
     P. S.
     Also you can pre-process header and body before returning Entity.
     */
    static func entity(header: Header, body: Body) -> Result<Entity, ABError>?
}

struct DataTransferResponseDefaultHeader: HeaderProtocol {
    init(headers: [AnyHashable: Any]?) throws { }
}

protocol DataTransferService {
    @discardableResult
    func performTask<Response: DataTransferResponse>(
        expecting: Response.Type,
        request: URLRequest,
        respondOnQueue: DispatchQueue,
        completion: @escaping (Result<Response.Entity, ABError>) -> Void
    ) -> Cancellable
    // TODO: delete lower functions
    @discardableResult
    func performTask<T: HeaderProvidingCodableType>(request: URLRequest, respondOnQueue: DispatchQueue, completion: @escaping (Result<T, ABError>) -> Void) -> Cancellable
    @discardableResult
    func performTask<T: Decodable>(request: URLRequest, respondOnQueue: DispatchQueue, completion: @escaping (Result<T, ABError>) -> Void) -> Cancellable
}

public class DefaultDataTransferService {
    @Inject private var networkService: NetworkService
}

extension DefaultDataTransferService: DataTransferService {
    func performTask<Response: DataTransferResponse>(
        expecting: Response.Type,
        request: URLRequest,
        respondOnQueue: DispatchQueue,
        completion: @escaping (Result<Response.Entity, ABError>) -> Void
    ) -> Cancellable {
        return networkService.request(request: request) { result in
            switch result {
            case .success(let response):
                guard let data = response.data else {
                    respondOnQueue.async { completion(.failure(.init(dataTransferError: .responseNotFound))) }
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let body    = try decoder.decode(Response.Body.self, from: data)
                    let header  = try Response.Header(headers: response.headerFields)
                    let result  = Response.entity(header: header, body: body)
                    if let result = result {
                        respondOnQueue.async { completion(result) }
                    } else {
                        respondOnQueue.async { completion(.failure(.init(dataTransferError: .responseNotFound))) }
                    }
                } catch {
                    respondOnQueue.async { completion(.failure(.init(dataTransferError: .parsingJSONFailure(error)))) }
                }
            case .failure(let error):
                respondOnQueue.async { completion(.failure(.init(dataTransferError: .networkFailure(error)))) }
            }
        }
    }

    func performTask<T>(request: URLRequest, respondOnQueue: DispatchQueue, completion: @escaping (Result<T, ABError>) -> Void) -> Cancellable where T: HeaderProvidingCodableType {
        let task = self.networkService.request(request: request) { result in
            switch result {
            case .success(let response):
                guard let data = response.data else {
                    respondOnQueue.async { completion(.failure(.init(dataTransferError: .responseNotFound))) }
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let decoded = try decoder.decode(T.T.self, from: data)
                    let decodedHeader = try T.H(headers: response.headerFields)

                    let result = T(codable: decoded, header: decodedHeader)
                    respondOnQueue.async { completion(.success(result)) }
                } catch {
                    respondOnQueue.async { completion(.failure(.init(dataTransferError: .parsingJSONFailure(error)))) }
                }
            case .failure(let error):
                respondOnQueue.async { completion(.failure(.init(dataTransferError: .networkFailure(error)))) }
            }
        }

        return task
    }

    func performTask<T>(request: URLRequest, respondOnQueue: DispatchQueue, completion: @escaping (Result<T, ABError>) -> Void) -> Cancellable where T: Decodable {
        let task = self.networkService.request(request: request) { result in
            switch result {
            case .success(let response):
                guard let data = response.data else {
                    respondOnQueue.async { completion(.failure(.init(dataTransferError: .responseNotFound))) }
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(T.self, from: data)
                    respondOnQueue.async { completion(.success(result)) }
                } catch {
                    respondOnQueue.async { completion(.failure(.init(dataTransferError: .parsingJSONFailure(error)))) }
                }
            case .failure(let error):
                respondOnQueue.async { completion(.failure(.init(dataTransferError: .networkFailure(error)))) }
            }
        }

        return task
    }
}
