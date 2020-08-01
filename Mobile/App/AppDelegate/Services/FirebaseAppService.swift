//
//  FirebaseAppService.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 7/28/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Firebase

public class FirebaseAppService: NSObject, AppDelegateServiceProvider {
    @discardableResult
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        return true
    }
}
