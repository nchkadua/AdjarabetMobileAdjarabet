//
//  AppDelegateServices.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 7/28/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation
import SDWebImageSVGCoder
import IQKeyboardManagerSwift

public class AppDelegateServices: NSObject, UIApplicationDelegate {
    private var services: [AppDelegateServiceProvider]

    public init(services: [AppDelegateServiceProvider]) {
        self.services = services
        super.init()
        //SVG
        let SVGCoder = SDImageSVGCoder.shared
        SDImageCodersManager.shared.addCoder(SVGCoder)
        //Keyboard
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false

        IQKeyboardManager.shared.keyboardDistanceFromTextField = UIScreen.main.nativeBounds.height / 8.2
    }

    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        services.map {
            $0.application?(application, didFinishLaunchingWithOptions: launchOptions) ?? false
        }.allSatisfy { $0 }
    }
}
