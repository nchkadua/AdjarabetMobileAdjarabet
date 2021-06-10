//
//  ActionOTPRepository.swift
//  Mobile
//
//  Created by Nika Chkadua on 6/10/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

protocol ActionOTPRepository {
    typealias ActionOTPHandler = (Result<ActionOTPEntity, Error>) -> Void
    func actionOTP(handler: @escaping ActionOTPHandler)
}
