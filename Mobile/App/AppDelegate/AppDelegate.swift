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
    private let services: AppDelegateServices

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        services.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    override init() {
        // Register all available services here
        services = AppDelegateServices(services: [
            FirebaseAppService()
        ])

        super.init()

        let dependencies = DependencyContainer.root.register {
            Module { DefaultLanguageStorage.shared as LanguageStorage }

            Module { UserSession.current as UserSessionServices }
            Module { UserSession.current as UserSessionReadableServices }

            Module { DefaultNetworkService() as NetworkService }
            Module { DefaultNetworkErrorLogger() as NetworkErrorLogger }
            Module { DefaultDataTransferService() as DataTransferService }

            Module { DefaultUserBalanceService.shared as UserBalanceService }
            Module { DefaultBiometricAuthentication() as BiometricAuthentication }

            Module { DefaultUserAgentProvider() as UserAgentProvider }
        }

        dependencies.build()
    }
}

public extension DependencyContainer {
    static var viewModels = DependencyContainer {
        Module { DefaultLoginViewModel() as LoginViewModel }
        Module { DefaultHomeViewModel() as HomeViewModel }
        Module { DefaultPromotionsViewModel() as PromotionsViewModel }
        Module { DefaultNotificationsViewModel() as NotificationsViewModel }
        Module { DefaultProfileViewModel() as ProfileViewModel }
        Module { DefaultAccountInfoViewModel() as AccountInfoViewModel }
        Module { DefaultCashFlowViewModel() as CashFlowViewModel }
        Module { DefaultDepositViewModel() as DepositViewModel }
        Module { DefaultWithdrawViewModel() as WithdrawViewModel }
        Module { DefaultCashFlowTabComponentViewModel() as CashFlowTabComponentViewModel }
    }

    static var repositories = DependencyContainer {
        // Core
        Module { DefaultAuthenticationRepository() as AuthenticationRepository }
        Module { DefaultBalanceManagementRepository() as BalanceManagementRepository }
        Module { DefaultSessionManagementRepository() as SessionManagementRepository }
        // Mobile
        Module { DefaultLobbyGamesRepository() as LobbyGamesRepository }

        Module { DefaultCookieStorageRepository() as CookieStorageRepository }
    }

    static var factories = DependencyContainer {
        Module { DefaultMainTabBarFactory() as MainTabBarFactory }
        Module { DefaultLoginViewControllerFactory() as LoginViewControllerFactory }
        Module { DefaultSMSLoginFactory() as SMSLoginFactory }
        Module { DefaultProfileFactory() as ProfileFactory }
        Module { DefaultNotificationContentFactory() as NotificationContentFactory }
        Module { DefaultAccountInfoViewControllerFactory() as AccountInfoViewControllerFactory }
        Module { DefaultCashFlowViewControllerFactory() as CashFlowViewControllerFactory }
        Module { DefaultDepositViewControllerFactory() as DepositViewControllerFactory }
        Module { DefaultWithdrawViewControllerFactory() as WithdrawViewControllerFactory }
    }

    static var useCases = DependencyContainer {
        Module { DefaultLoginUseCase() as LoginUseCase }
        Module { DefaultBiometricLoginUseCase(loginUseCase: DefaultLoginUseCase()) as BiometricLoginUseCase }
        Module { DefaultSMSCodeUseCase() as SMSCodeUseCase }
        Module { DefaultSMSLoginUseCase() as SMSLoginUseCase }
        Module { DefaultUserSessionUseCase() as UserSessionUseCase }
        Module { DefaultLobbyGamesUseCase() as LobbyGamesUseCase }
        Module { DefaultRecentlyPlayedGamesUseCase() as RecentlyPlayedGamesUseCase }
    }
}
