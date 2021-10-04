//
//  BonusItemDelegate.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 04.10.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public protocol BonusItemDelegate: AnyObject {
	func playButtonClicked(gameId: Int?)
	func hintButtonClicked(description: String, gameId: Int?)
}
