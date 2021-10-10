//
//  AccountRestriction.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 08.10.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct AccountRestriction {
	let type: AccountRestrictionType
	let until: Date?                    /// if type is 'none', 'unti' will be nil
}
