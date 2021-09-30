//
//  PromosUseCase.swift
//  Mobile
//
//  Created by Nika Chkadua on 30.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

protocol PromosUseCase {
    typealias PublicPromosHandler = (Result<PublicPromosEntity, ABError>) -> Void
    func getPublicPromos(handler: @escaping PublicPromosHandler)

    typealias PrivatePromosHandler = (Result<PrivatePromosEntity, ABError>) -> Void
    func getPrivatePromos(handler: @escaping PrivatePromosHandler)
}

struct DefaultPromosUseCase: PromosUseCase {
    @Inject(from: .repositories) private var postLoginRepo: PostLoginRepository
    @Inject(from: .repositories) private var publicPromosRepo: PublicPromosRepository
    @Inject(from: .repositories) private var privatePromosRepo: PrivatePromosRepository
    @Inject private var userSession: UserSessionReadableServices

    func getPublicPromos(handler: @escaping PublicPromosHandler) {
        postLoginRepo.userLoggedIn(params: .init(fromRegistration: false)) { result in
            switch result {
            case .success(let entity):
                publicPromosRepo.getPromos(segmentList: entity.segmentList ?? []) { result in
                    handler(result)
                }
            case .failure(let error): handler(.failure(error))
            }
        }
    }

    func getPrivatePromos(handler: @escaping PrivatePromosHandler) {
        postLoginRepo.userLoggedIn(params: .init(fromRegistration: false)) { result in
            switch result {
            case .success(let entity):
                privatePromosRepo.getPromos(segmentList: entity.segmentList ?? []) { result in
                    handler(result)
                }
            case .failure(let error): handler(.failure(error))
            }
        }
    }
}
