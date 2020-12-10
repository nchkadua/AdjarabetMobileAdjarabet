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

            Module { DefaultBiometryStorage.shared as BiometryReadableStorage }
            Module { DefaultBiometryStorage.shared as BiometryStorage }

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
        Module { DefaultTransactionsViewModel() as TransactionsViewModel }
        Module { DefaultBiometricSettingsViewModel() as BiometricSettingsViewModel }
        Module { DefaultP2PTransferViewModel() as P2PTransferViewModel }
        Module { DefaultSelfSuspendViewModel() as SelfSuspendViewModel }
        Module { DefaultMailChangeViewModel() as MailChangeViewModel }
        Module { DefaultAddressChangeViewModel() as AddressChangeViewModel }
        Module { DefaultPasswordChangeViewModel() as PasswordChangeViewModel }
        Module { DefaultTimerComponentViewModel() as TimerComponentViewModel }
        Module { DefaultTransactionsFilterViewModel() as TransactionsFilterViewModel }
        Module { DefaultAccountParametersViewModel(params: .init(accountParametersModel: .init())) as AccountParametersViewModel }
        Module { DefaultPhoneNumberChangeViewModel(params: .init()) as PhoneNumberChangeViewModel }
        Module { DefaultOTPViewModel(params: .init()) as OTPViewModel }
        Module { DefaultAccessHistoryViewModel(params: .init()) as AccessHistoryViewModel }
        Module { DefaultAddCardViewModel(params: .init()) as AddCardViewModel }
        Module { DefaultCardInfoViewModel(params: .init()) as CardInfoViewModel }
        Module { DefaultSecurityLevelsViewModel() as SecurityLevelsViewModel }
    }

    static var componentViewModels = DependencyContainer {
        Module { DefaultCalendarComponentViewModel() as CalendarComponentViewModel }
        Module { DefaultCashFlowTabComponentViewModel() as CashFlowTabComponentViewModel }
        Module { DefaultMinAmountComponentViewModel() as MinAmountComponentViewModel }
        Module { DefaultAgreementComponentViewModel() as AgreementComponentViewModel }
        Module { DefaultCreditCardComponentViewModel() as CreditCardComponentViewModel }
    }

    static var repositories = DependencyContainer {
        // Core
        Module { CoreApiUserProfileRepository.shared as UserInfoReadableRepository }
        Module { DefaultAuthenticationRepository() as AuthenticationRepository }
        Module { DefaultBalanceManagementRepository() as BalanceManagementRepository }
        Module { DefaultSessionManagementRepository() as SessionManagementRepository }
        // Mobile
        Module { DefaultLobbyGamesRepository() as LobbyGamesRepository }

        Module { DefaultCookieStorageRepository() as CookieStorageRepository }
        Module { CoreApiTransactionHistoryRepository.shared as TransactionHistoryRepository }
        Module { CoreApiAccessListRepository.shared as AccessListRepository }
    }

    static var factories = DependencyContainer {
        Module { DefaultMainTabBarFactory() as MainTabBarFactory }
        Module { DefaultLoginViewControllerFactory() as LoginViewControllerFactory }
        Module { DefaultOTPFactory() as OTPFactory }
        Module { DefaultProfileFactory() as ProfileFactory }
        Module { DefaultNotificationContentFactory() as NotificationContentFactory }
        Module { DefaultAccountInfoViewControllerFactory() as AccountInfoViewControllerFactory }
        Module { DefaultCashFlowViewControllerFactory() as CashFlowViewControllerFactory }
        Module { DefaultDepositViewControllerFactory() as DepositViewControllerFactory }
        Module { DefaultWithdrawViewControllerFactory() as WithdrawViewControllerFactory }
        Module { DefaultTransactionsViewControllerFactory() as TransactionsViewControllerFactory }
        Module { DefaultBiometricSettingsViewControllerFactory() as BiometricSettingsViewControllerFactory }
        Module { DefaultTransactionDetailsViewControllerFactory() as TransactionDetailsViewControllerFactory }
        Module { DefaultP2PTransferViewControllerFactory() as P2PTransferViewControllerFactory }
        Module { DefaultSelfSuspendViewControllerFactory() as SelfSuspendViewControllerFactory }
        Module { DefaultMailChangeViewControllerFactory() as MailChangeViewControllerFactory }
        Module { DefaultAddressChangeViewControllerFactory() as AddressChangeViewControllerFactory }
        Module { DefaultPasswordChangeViewControllerFactory() as PasswordChangeViewControllerFactory }
        Module { DefaultTransactionsFilterViewControllerFactory() as TransactionsFilterViewControllerFactory }
        Module { DefaultAccountParametersViewControllerFactory() as AccountParametersViewControllerFactory }
        Module { DefaultPhoneNumberChangeViewControllerFactory() as PhoneNumberChangeViewControllerFactory }
        Module { DefaultAccessHistoryViewControllerFactory() as AccessHistoryViewControllerFactory }
        Module { DefaultAddCardViewControllerFactory() as AddCardViewControllerFactory }
        Module { DefaultCardInfoViewControllerFactory() as CardInfoViewControllerFactory }
        Module { DefaultSecurityLevelsViewControllerFactory() as SecurityLevelsViewControllerFactory }
    }

    static var useCases = DependencyContainer {
        Module { DefaultLoginUseCase() as LoginUseCase }
        Module { DefaultBiometricLoginUseCase(loginUseCase: DefaultLoginUseCase()) as BiometricLoginUseCase }
        Module { DefaultSMSCodeUseCase() as SMSCodeUseCase }
        Module { DefaultOTPUseCase() as OTPUseCase }
        Module { DefaultUserSessionUseCase() as UserSessionUseCase }
        Module { DefaultLobbyGamesUseCase() as LobbyGamesUseCase }
        Module { DefaultRecentlyPlayedGamesUseCase() as RecentlyPlayedGamesUseCase }
        Module { DefaultDisplayTransactionHistoriesUseCase() as DisplayTransactionHistoriesUseCase }
        Module { DefaultAccessListUseCaseUseCase() as DisplayAccessListUseCase }
    }
}
