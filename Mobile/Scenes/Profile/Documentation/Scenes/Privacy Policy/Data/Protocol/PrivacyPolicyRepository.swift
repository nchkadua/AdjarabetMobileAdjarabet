//
//  PrivacyPolicyRepository.swift
//  Mobile
//
//  Created by Nika Chkadua on 13.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

protocol PrivacyPolicyRepository {
    typealias PrivacyPolicyHandler = (Result<PrivacyPolicyEntity, ABError>) -> Void
    func getUrl(handler: @escaping PrivacyPolicyHandler)
}
