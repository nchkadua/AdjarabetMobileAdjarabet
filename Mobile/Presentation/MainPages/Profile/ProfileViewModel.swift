//
//  ProfileViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/1/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol ProfileViewModel: ProfileViewModelInput, ProfileViewModelOutput {
}

public struct ProfileViewModelParams {
    public var profileInfo: ProfileInfoTableViewCellDataProvider
}

public protocol ProfileViewModelInput {
    func viewDidLoad()
}

public protocol ProfileViewModelOutput {
    var action: Observable<ProfileViewModelOutputAction> { get }
    var route: Observable<ProfileViewModelRoute> { get }
}

public enum ProfileViewModelOutputAction {
    case initialize(AppListDataProvider)
    case didCopyUserId(userId: String)
}

public enum ProfileViewModelRoute {
    case openPage(destionation: ProfileNavigator.Destination)
    case openBalance
    case openDeposit
    case openWithdraw
}

public class DefaultProfileViewModel: DefaultBaseViewModel {
    private let actionSubject = PublishSubject<ProfileViewModelOutputAction>()
    private let routeSubject = PublishSubject<ProfileViewModelRoute>()

    @Inject private var userSession: UserSessionServices
    @Inject private var userBalanceService: UserBalanceService
}

extension DefaultProfileViewModel: ProfileViewModel {
    public var action: Observable<ProfileViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<ProfileViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        var dataProviders: AppCellDataProviders = [
            DefaultQuickActionsHeaderViewModel(params: QuickActionsHeaderViewModelParams()),
            DefaultFooterComponentViewModel(params: FooterComponentViewModelParams(backgroundColor: DesignSystem.Color.secondaryBg()))
        ]

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
            case .didClickBalance: self?.routeSubject.onNext(.openBalance)
            case .didClickDeposit: self?.routeSubject.onNext(.openDeposit)
            case .didClickWithdraw: self?.routeSubject.onNext(.openWithdraw)
            default: break
            }
        }).disposed(by: self.disposeBag)
        dataProviders.insert(balanceViewModel, at: 1)

        QuickActionItemProvider.items().reversed().forEach {
            let quickActionViewModel = DefaultQuickActionComponentViewModel(params: QuickActionComponentViewModelParams(icon: $0.icon, title: $0.title, hidesSeparator: $0.hidesSeparator, destination: $0.destionation, roundedCorners: $0.roundedCorners))

            quickActionViewModel.action.subscribe(onNext: { [weak self] action in
                switch action {
                case .didSelect: self?.routeSubject.onNext(.openPage(destionation: quickActionViewModel.params.destination))
                default: break
                }
            }).disposed(by: self.disposeBag)

            dataProviders.insert(quickActionViewModel, at: 3)
        }

        actionSubject.onNext(.initialize(dataProviders.makeList()))
    }
}
