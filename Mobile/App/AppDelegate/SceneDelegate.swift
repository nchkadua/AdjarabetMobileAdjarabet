//
//  SceneDelegate.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        window?.rootViewController = DefaultLoginViewControllerFactory().make(params: LoginViewModelParams(showBiometryLoginAutomatically: true)).wrap(in: ABNavigationController.self)
    }
}
