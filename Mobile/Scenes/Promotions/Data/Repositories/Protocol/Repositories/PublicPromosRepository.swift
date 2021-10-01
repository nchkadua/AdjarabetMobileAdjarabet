//
//  PublicPromosRepository.swift
//  Mobile
//
//  Created by Nika Chkadua on 30.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

protocol PublicPromosRepository {
    typealias PublicPromosHandler = (Result<PublicPromosEntity, ABError>) -> Void
    func getPromos(segmentList: [String], handler: @escaping PublicPromosHandler)
}
