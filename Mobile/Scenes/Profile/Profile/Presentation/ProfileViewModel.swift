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
    func viewDidAppear()
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

    public func viewDidAppear() {
        userBalanceService.update()
    }

    public func setupDataProviders() {
        setupAppCellDataProviders()
    }

	// MARK: - View Models for profile table view
	private var profileViewModel: DefaultProfileInfoComponentViewModel {
		let profileViewModel = DefaultProfileInfoComponentViewModel(params: ProfileInfoComponentViewModelParams(username: userSession.username ?? "Guest", userId: userSession.userId ?? 0))
		profileViewModel.action.subscribe(onNext: { [weak self] action in
			switch action {
			case .didCopyUserId: self?.actionSubject.onNext(.didCopyUserId(userId: "userID"))
			default: break
			}
		}).disposed(by: self.disposeBag)

		return profileViewModel
	}

	private var balanceViewModel: DefaultBalanceComponentViewModel {
		let balanceViewModel = DefaultBalanceComponentViewModel(params: .init(totalBalance: userBalanceService.balance ?? 0, pokerBalance: 0, balancePlaceholder: R.string.localization.balance_is_unavailable.localized()))

		if userBalanceService.balance != nil {
			balanceViewModel.showBalance()
		} else {
			balanceViewModel.hideBalance()
		}

		balanceViewModel.action.subscribe(onNext: { [weak self] action in
			switch action {
			case .didClickDeposit: self?.routeSubject.onNext(.openDeposit)
			case .didClickWithdraw: self?.routeSubject.onNext(.openWithdraw)
			default: break
			}
		}).disposed(by: self.disposeBag)

		return balanceViewModel
	}

	private var logOutViewModel: DefaultLogOutComponentViewModel {
		let logOutViewModel = DefaultLogOutComponentViewModel(params: .init(title: R.string.localization.log_out.localized()))
		logOutViewModel.action.subscribe(onNext: { [weak self] action in
			switch action {
			case .didTapButton: self?.routeSubject.onNext(.openPage(destionation: .loginPage))
			default:
				break
			}
		}).disposed(by: self.disposeBag)
		return logOutViewModel
	}

	private var footerViewModel: DefaultFooterComponentViewModel {
		let footerViewModel = DefaultFooterComponentViewModel(params: FooterComponentViewModelParams(backgroundColor: DesignSystem.Color.secondaryBg()))
		footerViewModel.action.subscribe(onNext: {[weak self] action in
			switch action {
			case .contactUsDidClick: self?.routeSubject.onNext(.openContactUs)
			case .didChangeLanguage: self?.actionSubject.onNext(.languageDidChange)
			default:
				break
			}
		}).disposed(by: self.disposeBag)
		return footerViewModel
	}

	private var quickActionViewModels: AppCellDataProviders {
		var viewModels: AppCellDataProviders = []
		QuickActionItemProvider.items(biometryQuickActionIcon()).forEach {
			let quickActionViewModel = DefaultQuickActionComponentViewModel(params: QuickActionComponentViewModelParams(icon: $0.icon, title: $0.title, destination: $0.destionation))

			quickActionViewModel.action.subscribe(onNext: { [weak self] action in
				switch action {
				case .didSelect: self?.routeSubject.onNext(.openPage(destionation: quickActionViewModel.params.destination))
				default: break
				}
			}).disposed(by: self.disposeBag)
			viewModels.append(quickActionViewModel)
		}
		return viewModels
	}

    private func setupAppCellDataProviders() {
        var dataProviders: AppCellDataProviders = []

		userBalanceService.update()

        dataProviders.append(profileViewModel)
        dataProviders.append(balanceViewModel)
		for quickActionViewModel in quickActionViewModels {
			dataProviders.append(quickActionViewModel)
		}

		logoutViewModel = logOutViewModel	// FIXME
		dataProviders.append(logoutViewModel)
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
