//
//  StatusMessageComponentConstants.swift.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 10.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct StatusMessageComponentConstants {
	struct Colors {
		static let green = UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 1)
		static let red = UIColor(red: 255/255, green: 69/255, blue: 58/255, alpha: 1)
	}
	
	static let heightConstraintIdentifier = "statusMessageView.height"
	
	static var preferredHeight: CGFloat {
		hasSwipeIndicator ? preferredHeightForDevicesWithSwipeIndicator : preferredHeightForDevicesWithoutSwipeIndicator
	}
	
	private static var hasSwipeIndicator: Bool {
		if #available(iOS 11.0, *), let keyWindow = UIApplication.shared.windows.filter({$0.isKeyWindow}).first, keyWindow.safeAreaInsets.bottom > 0 {
			return true
		}
		return false
	}
	private static var preferredHeightForDevicesWithoutSwipeIndicator: CGFloat = 30
	private static var preferredHeightForDevicesWithSwipeIndicator: CGFloat = preferredHeightForDevicesWithoutSwipeIndicator + 13
}
