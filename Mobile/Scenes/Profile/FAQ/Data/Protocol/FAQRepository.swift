//
//  FAQRepository.swift
//  Mobile
//
//  Created by Nika Chkadua on 22.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

protocol FAQRepository {
    typealias FAQHandler = (Result<FAQEntity, ABError>) -> Void
    func getList(handler: @escaping FAQHandler)
}
