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
        true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    override init() {
        super.init()

        let dependencies = DependencyContainer.root.register {
            Module { DefaultLanguageStorage.shared as LanguageStorage }

            Module { UserSession.current as UserSessionServices }
            Module { UserSession.current as UserSessionReadableServices }

            Module { DefaultNetworkService() as NetworkService }
            Module { DefaultNetworkErrorLogger() as NetworkErrorLogger }
            Module { DefaultDataTransferService() as DataTransferService }
            Module { AdjarabetCoreClientRequestBuilder() as AdjarabetCoreClientRequestBuilder }
            Module { AdjarabetMobileClientRequestBuilder() as AdjarabetMobileClientRequestBuilder }

            Module { DefaultUserBalanceService.shared as UserBalanceService }
            Module { DefaultBiometryAuthentication() as BiometryAuthentication }

            Module { DefaultUserAgentProvider() as UserAgentProvider }
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
        // Core
        Module { DefaultAuthenticationRepository() as AuthenticationRepository }
        Module { DefaultBalanceManagementRepository() as BalanceManagementRepository }
        Module { DefaultSessionManagementRepository() as SessionManagementRepository }
        // Mobile
        Module { DefaultGameRepository() as GameRepository }

        Module { DefaultCookieStorageRepository() as CookieStorageRepository }
    }

    static var factories = DependencyContainer {
        Module { DefaultMainTabBarFactory() as MainTabBarFactory }
        Module { DefaultSMSLoginFactory() as SMSLoginFactory }
    }

    static var useCases = DependencyContainer {
        Module { DefaultLoginUseCase() as LoginUseCase }
        Module { DefaultSMSCodeUseCase() as SMSCodeUseCase }
        Module { DefaultSMSLoginUseCase() as SMSLoginUseCase }
        Module { DefaultUserSessionUseCase() as UserSessionUseCase }
    }
}
