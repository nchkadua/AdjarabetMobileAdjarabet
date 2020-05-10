//
//  AppDelegate.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    override init() {
        super.init()

        let dependencies = DependencyContainer.root.register {
            Module { AdjarabetWebAPIClient(baseUrl: AdjarabetEndpoints.coreAPIUrl) as AdjarabetWebAPIServices }
            Module { DefaultLanguageStorage.shared as LanguageStorage }
            Module { UserSession.current as UserSessionServices }

            Module { DefaultNetworkService() as NetworkService }
            Module { DefaultNetworkErrorLogger() as NetworkErrorLogger }
            Module { DefaultDataTransferService() as DataTransferService }
            Module { AdjarabetCoreClientRequestBuilder.shared as AdjarabetCoreClientRequestBuilder }
        }

        dependencies.build()
    }
}

public extension DependencyContainer {
    static var viewModels = DependencyContainer {
        Module { DefaultHomeViewModel() as HomeViewModel }
        Module { DefaultPromotionsViewModel() as PromotionsViewModel }
        Module { DefaultNotificationsViewModel() as NotificationsViewModel }
    }

    static var repositories = DependencyContainer {
        Module { DefaultAuthenticationRepository() as AuthenticationRepository }
    }
}
