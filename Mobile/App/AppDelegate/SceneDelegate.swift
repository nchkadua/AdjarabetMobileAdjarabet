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
        guard let scene = (scene as? UIWindowScene) else { return }
    
        let window = UIWindow(windowScene: scene)
        self.window = window
        let viewModelParams = LoginViewModelParams(showBiometryLoginAutomatically: true)
        let vc = DefaultLoginViewControllerFactory().make(params: viewModelParams)
        let wrappedVC = vc.wrap(in: ABNavigationController.self)
        window.rootViewController = wrappedVC
    }
}
