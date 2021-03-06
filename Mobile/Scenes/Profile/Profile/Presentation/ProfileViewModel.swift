//
//  ProfileViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/1/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

protocol ProfileViewModel: BaseViewModel, ProfileViewModelInput, ProfileViewModelOutput {
}

public struct ProfileViewModelParams {
    public var profileInfo: ProfileInfoTableViewCellDataProvider
}

public protocol ProfileViewModelInput {
    func viewDidLoad()
    func logout()
    func setupDataProviders()
}

public protocol ProfileViewModelOutput {
    var action: Observable<ProfileViewModelOutputAction> { get }
    var route: Observable<ProfileViewModelRoute> { get }
}

public enum ProfileViewModelOutputAction {
    case initialize(AppListDataProvider)
    case didCopyUserId(userId: String)
    case didLogoutWithSuccess
    case didLogoutWithError(error: Error)
    case languageDidChange
}

public enum ProfileViewModelRoute {
    case openPage(destionation: ProfileNavigator.Destination)
    case openDeposit
    case openWithdraw
    case openContactUs
}

public class DefaultProfileViewModel: DefaultBaseViewModel {
    private let actionSubject = PublishSubject<ProfileViewModelOutputAction>()
    private let routeSubject = PublishSubject<ProfileViewModelRoute>()

    @Inject private var userSession: UserSessionServices
    @Inject private var userBalanceService: UserBalanceService
    @Inject(from: .useCases) private var logoutUseCase: LogoutUseCase
    @Inject private var biometryInfoService: BiometricAuthentication

    private var logoutViewModel = DefaultLogOutComponentViewModel(params: .init(title: ""))
}

extension DefaultProfileViewModel: ProfileViewModel {
    public var action: Observable<ProfileViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<ProfileViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        setupDataProviders()
    }

    public func setupDataProviders() {
        setupAppCellDataProviders()
    }

    private func setupAppCellDataProviders() {
        var dataProviders: AppCellDataProviders = []

        let profileViewModel = DefaultProfileInfoComponentViewModel(params: ProfileInfoComponentViewModelParams(username: userSession.username ?? "Guest", userId: userSession.userId ?? 0))
        profileViewModel.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .didCopyUserId: self?.actionSubject.onNext(.didCopyUserId(userId: "userID"))
            default: break
            }
        }).disposed(by: self.disposeBag)
        dataProviders.insert(profileViewModel, at: 0)

        let balanceViewModel = DefaultBalanceComponentViewModel(params: BalanceComponentViewModelParams(totalBalance: userBalanceService.balance ?? 0, pokerBalance: 0))
        balanceViewModel.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .didClickDeposit: self?.routeSubject.onNext(.openDeposit)
            case .didClickWithdraw: self?.routeSubject.onNext(.openWithdraw)
            default: break
            }
        }).disposed(by: self.disposeBag)
        dataProviders.insert(balanceViewModel, at: 1)

        logoutViewModel = DefaultLogOutComponentViewModel(params: .init(title: R.string.localization.log_out.localized()))
        logoutViewModel.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .didTapButton: self?.routeSubject.onNext(.openPage(destionation: .loginPage))
            default:
                break
            }
        }).disposed(by: self.disposeBag)
        dataProviders.insert(logoutViewModel, at: 2)

        QuickActionItemProvider.items(biometryQuickActionIcon()).reversed().forEach {
            let quickActionViewModel = DefaultQuickActionComponentViewModel(params: QuickActionComponentViewModelParams(icon: $0.icon, title: $0.title, destination: $0.destionation))

            quickActionViewModel.action.subscribe(onNext: { [weak self] action in
                switch action {
                case .didSelect: self?.routeSubject.onNext(.openPage(destionation: quickActionViewModel.params.destination))
                default: break
                }
            }).disposed(by: self.disposeBag)

            dataProviders.insert(quickActionViewModel, at: 2)
        }

        let footerViewModel = DefaultFooterComponentViewModel(params: FooterComponentViewModelParams(backgroundColor: DesignSystem.Color.secondaryBg()))
        footerViewModel.action.subscribe(onNext: {[weak self] action in
            switch action {
            case .contactUsDidClick: self?.routeSubject.onNext(.openContactUs)
            case .didChangeLanguage: self?.actionSubject.onNext(.languageDidChange)
            default:
                break
            }
        }).disposed(by: self.disposeBag)
        dataProviders.append(footerViewModel)

        actionSubject.onNext(.initialize(dataProviders.makeList()))
    }

    public func logout() {
        logoutUseCase.execute(userId: userSession.userId ?? -1, sessionId: userSession.sessionId ?? "", completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.actionSubject.onNext(.didLogoutWithSuccess)
                self.logoutViewModel.endLoading()
            case .failure(.unknown(let error)): self.actionSubject.onNext(.didLogoutWithError(error: error))
            }
        })
    }

    private func biometryQuickActionIcon() -> UIImage {
        let icon: UIImage
        switch biometryInfoService.biometryType {
        case .touchID:  icon = R.image.components.quickAction.touch_id()!
        case .faceID:   icon = R.image.components.quickAction.face_id()!
        default:        icon = R.image.components.quickAction.touch_id()!
        }

        return icon
    }
}
