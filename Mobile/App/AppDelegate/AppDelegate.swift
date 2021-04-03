//
//  AppDelegate.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import UIKit
import SDWebImageSVGCoder

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    private let services: AppDelegateServices

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //SVG
        let SVGCoder = SDImageSVGCoder.shared
        SDImageCodersManager.shared.addCoder(SVGCoder)

        return services.application(application, didFinishLaunchingWithOptions: launchOptions)
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

            Module { HttpRequestBuilderImpl.createInstance() as HttpRequestBuilder }
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
        Module { DefaultDepositViewModel(params: .init()) as DepositViewModel }
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
        Module { DefaultAddCardViewModel(params: .init()) as AddCardViewModel }
        Module { DefaultSecurityLevelsViewModel() as SecurityLevelsViewModel }
        Module { DefaultAccessHistoryCalendarViewModel(params: .init()) as AccessHistoryCalendarViewModel }
        Module { DefaultAccessHistoryViewModel(params: .init()) as AccessHistoryViewModel }
        Module { DefaultMyCardsViewModel() as MyCardsViewModel }
        Module { DefaultVisaViewModel(params: .init(serviceType: .regular)) as VisaViewModel }
        Module { DefaultEmoneyViewModel() as EmoneyViewModel }
        Module { DefaultMainContainerViewModel(params: .init()) as MainContainerViewModel }
    }

    static var componentViewModels = DependencyContainer {
        Module { DefaultCalendarComponentViewModel() as CalendarComponentViewModel }
        Module { DefaultMinAmountComponentViewModel() as MinAmountComponentViewModel }
        Module { DefaultAgreementComponentViewModel() as AgreementComponentViewModel }
        Module { DefaultGameLoaderComponentViewModel() as GameLoaderComponentViewModel }
        Module { DefaultPaymentMethodGridComponentViewModel(params: .init(paymentMethods: [])) as PaymentMethodGridComponentViewModel }
        Module { DefaultSuggestedAmountGridComponentViewModel(params: .init(suggestedAmouns: [])) as SuggestedAmountGridComponentViewModel }
    }

    static var repositories = DependencyContainer {
        // Core
        Module { CoreApiUserProfileRepository() as UserInfoReadableRepository }
        Module { DefaultAuthenticationRepository() as AuthenticationRepository }
        Module { DefaultBalanceManagementRepository() as BalanceManagementRepository }
        Module { DefaultSessionManagementRepository() as SessionManagementRepository }
        Module { CoreApiPaymentAccountRepository() as PaymentAccountRepository }
        // Mobile
        Module { DefaultLobbyGamesRepository() as LobbyGamesRepository }
        Module { DefaultNotificationsRepository() as NotificationsRepository }
        // Payments
        Module { DefaultPostLoginRepository() as PostLoginRepository }
        Module { DefaultPaymentListRepository() as PaymentListRepository }
        Module { DefaultTBCRegularPaymentsRepository() as TBCRegularPaymentsRepository }
        // Payments.UFC
        Module { DefaultUFCTransactionRepository() as UFCDepositRepository }
        Module { DefaultUFCTransactionRepository() as UFCWithdrawRepository }
        Module { DefaultUFCTransactionRepository() as UFCTransactionRepository }

        Module { DefaultCookieStorageRepository() as CookieStorageRepository }
        Module { CoreApiTransactionHistoryRepository() as TransactionHistoryRepository }
        Module { CoreApiAccessListRepository() as AccessListRepository }
    }

    static var factories = DependencyContainer {
        Module { DefaultMainTabBarFactory() as MainTabBarFactory }
        Module { DefaultLoginViewControllerFactory() as LoginViewControllerFactory }
        Module { DefaultOTPFactory() as OTPFactory }
        Module { DefaultProfileFactory() as ProfileFactory }
        Module { DefaultNotificationContentFactory() as NotificationContentFactory }
        Module { DefaultAccountInfoViewControllerFactory() as AccountInfoViewControllerFactory }
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
        Module { DefaultSecurityLevelsViewControllerFactory() as SecurityLevelsViewControllerFactory }
        Module { DefaultAccessHistoryCalendarViewControllerFactory() as AccessHistoryCalendarViewControllerFactory }
        Module { DefaultMyCardsViewControllerFactory() as MyCardsViewControllerFactory }
        Module { DefaultGameViewControllerFactory() as GameViewControllerFactory }
        Module { DefaultWebViewControllerFactory() as WebViewControllerFactory }
        // Payments
        Module { UFCTransactionParamsFactory() as UFCTransactionParamsFactory }
        Module { DefaultVisaViewControllerFactory() as VisaViewControllerFactory }
        Module { DefaultEmoneyViewControllerFactory() as EmoneyViewControllerFactory }
        Module { DefaultMainContainerViewControllerFactory() as MainContainerViewControllerFactory }
    }

    static var useCases = DependencyContainer {
        // Modile
        Module { DefaultLobbyGamesUseCase() as LobbyGamesUseCase }
        Module { DefaultRecentlyPlayedGamesUseCase() as RecentlyPlayedGamesUseCase }
        Module { DefaultNotificationsUseCase() as NotificationsUseCase }
        // Core
        Module { DefaultLoginUseCase() as LoginUseCase }
        Module { DefaultBiometricLoginUseCase(loginUseCase: DefaultLoginUseCase()) as BiometricLoginUseCase }
        Module { DefaultSMSCodeUseCase() as SMSCodeUseCase }
        Module { DefaultOTPUseCase() as OTPUseCase }
        Module { DefaultUserSessionUseCase() as UserSessionUseCase }
        Module { DefaultDisplayTransactionHistoriesUseCase() as DisplayTransactionHistoriesUseCase }
        Module { DefaultAccessListUseCaseUseCase() as DisplayAccessListUseCase }
        Module { DefaultPaymentAccountUseCase() as PaymentAccountUseCase }
        Module { DefaultLogoutUseCase() as LogoutUseCase }
        Module { DefaultAmountFormatterUseCase() as AmountFormatterUseCase }
        // Payments
        Module { DefaultPaymentListUseCase() as PaymentListUseCase }
        Module { UFCDepositUseCase() as UFCDepositUseCase }
        Module { UFCWithdrawUseCase() as UFCWithdrawUseCase }
    }
}
