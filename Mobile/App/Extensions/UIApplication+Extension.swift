//
//  UIApplication+Extension.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/24/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public extension UIApplication {
    var currentWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .map { $0 as? UIWindowScene }
            .compactMap { $0 }
            .first?.windows
            .filter { $0.isKeyWindow }.first
    }
}
