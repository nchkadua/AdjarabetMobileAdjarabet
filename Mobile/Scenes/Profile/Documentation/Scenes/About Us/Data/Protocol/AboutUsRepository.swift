//
//  AboutUsRepository.swift
//  Mobile
//
//  Created by Nika Chkadua on 27.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

protocol AboutUsRepository {
    typealias AboutUsHandler = (Result<AboutUsEntity, ABError>) -> Void
    func getUrl(handler: @escaping AboutUsHandler)
}
