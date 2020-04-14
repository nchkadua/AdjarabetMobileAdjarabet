//
//  AdjarabetCoreClient.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public class AdjarabetCoreClient: AdjarabetCoreServices {
    public let baseUrl: URL

    public init(baseUrl: URL) {
        self.baseUrl = baseUrl
    }

    public var baseUrlComponents: URLComponents {
        URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)!
    }

    public enum Method: String {
        case login
        case loginOtp
        case balance = "getBalance"
        case smsCode = "getSmsCode"
        case logout
        case aliveSession = "isSessionActive"
    }
}

public extension AdjarabetCoreClient {
    func performTask<T: AdjarabetCoreCodableType>(
        request: URLRequest, type: T.Type,
        completion: ((_ response: Result<T, Error>) -> Void)?) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let httpResponse = response as? HTTPURLResponse
//            print(httpResponse?.allHeaderFields ?? [:])

            if let error = error {
                DispatchQueue.main.async { completion?(.failure(error)) }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion?(.failure(AdjarabetCoreClientError.dataIsEmpty(context: request.url!)))
                }
                return
            }

            let jsonDecoder = JSONDecoder()
            do {
//                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                print(json)

                let statusCode = try jsonDecoder.decode(AdjarabetCoreCodable.StatusCodeChecker.self, from: data)
                if !statusCode.isSuccess {
                    throw AdjarabetCoreClientError.invalidStatusCode(code: statusCode.code)
                }

                let decoded = try jsonDecoder.decode(T.T.self, from: data)
                let decodedHeader = try T.H(headers: httpResponse?.allHeaderFields)

                let res = T(codable: decoded, header: decodedHeader)
                DispatchQueue.main.async {
                    completion?(.success(res))
                }
            } catch let DecodingError.dataCorrupted(context) {
                print(context)
                DispatchQueue.main.async {
                    completion?(.failure(DecodingError.dataCorrupted(context)))
                }
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
                DispatchQueue.main.async {
                    completion?(.failure(DecodingError.keyNotFound(key, context)))
                }
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
                DispatchQueue.main.async {
                    completion?(.failure(DecodingError.valueNotFound(value, context)))
                }
            } catch let DecodingError.typeMismatch(type, context) {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
                DispatchQueue.main.async {
                    completion?(.failure(DecodingError.typeMismatch(type, context)))
                }
            } catch {
                DispatchQueue.main.async {
                    completion?(.failure(error))
                }
            }
        }

        task.resume()
    }

//    fileprivate func performTask<T: Codable>(url: URL, type: T.Type, completion: ((_ response: Result<T, Error>) -> Void)?) {
//        let urlRequest = URLRequest(url: url)
//
//        let task = URLSession.shared.dataTask(with: urlRequest) { (data, urlResponse, error) in
//            if let error = error {
//                completion?(.failure(error))
//                return
//            }
//
//            guard let data = data else {
//                completion?(.failure(AdjarabetCoreClientError.dataIsEmpty(context: url)))
//                return
//            }
//
//            let jsonDecoder = JSONDecoder()
//            do {
//                let decoded = try jsonDecoder.decode(T.self, from: data)
//                completion?(.success(decoded))
//            } catch {
//                completion?(.failure(error))
//            }
//        }
//
//        task.resume()
//    }
}
