//
//  PrivatePromosRepository.swift
//  Mobile
//
//  Created by Nika Chkadua on 30.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

protocol PrivatePromosRepository {
    typealias PrivatePromosHandler = (Result<PrivatePromosEntity, ABError>) -> Void
    func getPromos(segmentList: [String], handler: @escaping PrivatePromosHandler)
}
