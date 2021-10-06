//
//  UserStatus.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 06.10.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

/// https://speca.io/singular/core-website-api/1.9.7?key=0743b52a9a946df6d6e6dfef7e5a337a#user-statuses
enum UserStatus: Int {		// Block Type
	case registered = 1		// None
	case verified			// None
	case fullBlock			// Fully Blocked
	case gameBlock			// Blocked from placing bets
	case withdrawBlocked	// Blocked from withdrawing amount from account balance
	case vip				// None

	var canPlay: Bool {
		switch self {
			case .fullBlock,
				 .gameBlock: return false
			default: return true
		}
	}

	var canWithdraw: Bool {
		switch self {
			case .fullBlock,
				 .withdrawBlocked: return true
			default: return false
		}
	}
}
