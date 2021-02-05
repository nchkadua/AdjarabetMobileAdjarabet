////
////  CoreApiGameLauchUrlRepository.swift
////  Mobile
////
////  Created by Giorgi Kratsashvili on 12/11/20.
////  Copyright © 2020 Adjarabet. All rights reserved.
////
//
//import Foundation
//
//public class CoreApiGameLauchUrlRepository {
//    public static let shared = CoreApiGameLauchUrlRepository()
//    @Inject private var dataTransferService: DataTransferService
//    @Inject private var userAgentProvider: UserAgentProvider
//    @Inject private var userSession: UserSessionServices
//}
//
//extension CoreApiGameLauchUrlRepository: GameLauchUrlRepository {
//    public func launchUrl(params: GameLauchUrlParams, completion: @escaping GameLauchUrlHandler) {
//        // TODO: Refactor with requestBuilder
//        let header = [
//            "accept": "application/json",
//            "accept-language": "en-US,en;q=0.9,ru;q=0.8",
//            "authorization": "Token e07c52c91add965f9b10383c04b13678",
//            "connection": "keep-alive",
//            "content-type": "application/json",
//            "origin": "https://app.mocklab.io",
//            "referer": "https://app.mocklab.io/",
//            "sec-fetch-dest": "empty",
//            "sec-fetch-mode": "cors",
//            "sec-fetch-site": "same-site",
//            "user-agent": userAgentProvider.userAgent, // "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.198 Safari/537.36", // userAgentProvider.userAgent
//            "Cookie": userSession.sessionId!, //"{% request 'cookie', 'JSESSIONID', 0 %}",
//            "Accept": "*/*",
//            "Content-Type": "application/json"
//        ]
//
//        let body: [String: Any] = [
//            "channel": 2,
//            "lang": "en",
//            "gameId": "7382",
//            "token": params.token,
//            "demo": false,
//            "provider": "EGT",
//            "exitUrl": "test.com",
//            "launchParameters": [
//              "gameId": "532_Portal"
//            ]
//        ]
//
//        let url = URL(string: "https://siswebapi.adjarabet-stage.com/api/v1/init")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.allHTTPHeaderFields = header
//        guard let jsonData = try? JSONSerialization.data(withJSONObject: body)
//        else { fatalError("launchUrl: cant parse request params") }
//        request.httpBody = jsonData
//
//        dataTransferService.performTask(expecting: GameLaunchUrlDataTransferResponse.self,
//                                        request: request, respondOnQueue: .main, completion: completion)
//    }
//}
