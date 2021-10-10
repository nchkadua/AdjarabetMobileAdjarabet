//
//  AccountRestrictionUseCase.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 07.10.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

protocol AccountRestrictionUseCase {
	typealias Handler = (Result<AccountRestriction, ABError>) -> Void

    /// Returns: Account restriction status
    func getStatus(completion: @escaping Handler)
}
