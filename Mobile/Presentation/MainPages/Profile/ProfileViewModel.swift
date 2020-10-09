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
}

public enum ProfileViewModelRoute {
    case openPage(title: String)
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
            DefaultFooterComponentViewModel(params: FooterComponentViewModelParams(isSeparatorViewHidden: true))
        ]

        let profileViewModel = DefaultProfileInfoComponentViewModel(params: ProfileInfoComponentViewModelParams(username: userSession.username ?? "Guest", userId: userSession.userId ?? 0))
        profileViewModel.action.subscribe(onNext: { action in
            switch action {
            case .didCopyUserId: self.routeSubject.onNext(.openPage(title: "User ID Copied"))
            default: break
            }
        }).disposed(by: self.disposeBag)
        dataProviders.insert(profileViewModel, at: 0)

        let balanceViewModel = DefaultBalanceComponentViewModel(params: BalanceComponentViewModelParams(totalBalance: userBalanceService.balance ?? 0, pokerBalance: 0))
        balanceViewModel.action.subscribe(onNext: { action in
            switch action {
            case .didClickBalance: self.routeSubject.onNext(.openPage(title: "Open Balance"))
            case .didClickDeposit: self.routeSubject.onNext(.openPage(title: "Open Deposit"))
            case .didClickWithdraw: self.routeSubject.onNext(.openPage(title: "Open Withdraw"))
            default: break
            }
        }).disposed(by: self.disposeBag)
        dataProviders.insert(balanceViewModel, at: 1)

        for quickAction in QuickActionItemProvider.items().reversed() {
            let quickActionViewModel = DefaultQuickActionComponentViewModel(params: QuickActionComponentViewModelParams(icon: quickAction.icon, title: quickAction.title))

            quickActionViewModel.action.subscribe(onNext: { action in
                switch action {
                case .didSelect(let quickActionViewModel, _): self.routeSubject.onNext(.openPage(title: quickActionViewModel.params.title))
                default: break
                }
            }).disposed(by: self.disposeBag)

            dataProviders.insert(quickActionViewModel, at: 3)
        }

        actionSubject.onNext(.initialize(dataProviders.makeList()))
    }
}
