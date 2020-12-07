//
//  AccountParametersViewModel.swift
//  Mobile
//
//  Created by Irakli Shelia on 12/1/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol AccountParametersViewModel: AccountParametersViewModelInput, AccountParametersViewModelOutput {
}

public struct AccountParametersViewModelParams {
    var accountParametersModel: AccountParametersModel
}

public protocol AccountParametersViewModelInput: AnyObject {
    var params: AccountParametersViewModelParams { get set }
    func viewDidLoad()
}

public protocol AccountParametersViewModelOutput {
    var action: Observable<AccountParametersViewModelOutputAction> { get }
    var route: Observable<AccountParametersViewModelRoute> { get }
}

public enum AccountParametersViewModelOutputAction {
    case languageDidChange
    case initialize(AppListDataProvider)
}

public enum AccountParametersViewModelRoute {
    case openPage(_ destination: AccountParametersNavigator.Destination)
    case openOTP(params: OTPViewModelParams)
}

public class DefaultAccountParametersViewModel: DefaultBaseViewModel {
    public var params: AccountParametersViewModelParams
    private let actionSubject = PublishSubject<AccountParametersViewModelOutputAction>()
    private let routeSubject = PublishSubject<AccountParametersViewModelRoute>()

    public init(params: AccountParametersViewModelParams) {
        self.params = params
    }

    public override func languageDidChange() {
        super.languageDidChange()
        actionSubject.onNext(.languageDidChange)
    }
}

extension DefaultAccountParametersViewModel: AccountParametersViewModel {
    public var action: Observable<AccountParametersViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<AccountParametersViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        setupAccountParamters()
    }

    private func setupAccountParamters() {
        var dataProvider: AppCellDataProviders = []
        var componentViewModel: AppCellDataProvider?
        params.accountParametersModel.dataSource.forEach {
            if let accountParameterModel = $0 as? AccountParameter {
                componentViewModel = DefaultAccountParametersComponentViewModel(params: .init(title: accountParameterModel.title,
                                                                                              icon: accountParameterModel.icon))
                if let defaultViewModel = componentViewModel as? DefaultAccountParametersComponentViewModel {
                    defaultViewModel.action.subscribe(onNext: { [weak self] action in
                        switch action {
                        case .didSelect: self?.goToDestination(accountParameterModel.destination)
                        default:
                            break
                        }
                    })
                }
            } else if let accountParameterMessagesModel = $0 as? AccountParameterMessages {
                componentViewModel = DefaultAccountSecurityMessagesComponentViewModel(params: .init(title: accountParameterMessagesModel.title,
                                                                                                    description: accountParameterMessagesModel.description, buttonTitle: accountParameterMessagesModel.buttonTitle,
                                                                                                    switchState: accountParameterMessagesModel.switchState))
            } else if let accountParameterHeaderModel = $0 as? AccountParameterHeader {
                componentViewModel = DefaultAccountParametersHeaderComponentViewModel(params: .init(title: accountParameterHeaderModel.title))
            }
            dataProvider.append(componentViewModel!)
        }

        //TODO subscribe to switch toggle
        actionSubject.onNext(.initialize(dataProvider.makeList()))
    }

    private func createAccountParameterComponentViewModel(params: AccountParameter) -> AccountParametersComponentViewModel {
        DefaultAccountParametersComponentViewModel(params: .init(title: params.title,
                                                                 icon: params.icon))
    }

    private func goToDestination(_ destination: AccountParametersNavigator.Destination) {
        switch destination {
        case .highSecurity: goToHighSecurity()
        default: routeSubject.onNext(.openPage(destination))
        }
    }

    private func goToHighSecurity() {
        let otpParams: OTPViewModelParams = .init(vcTitle: R.string.localization.high_security_page_title.localized(), buttonTitle: R.string.localization.high_security_button_on(), showDismissButton: false, username: "")
        routeSubject.onNext(.openOTP(params: otpParams))
        subscribeTo(otpParams)
    }

    private func subscribeTo(_ params: OTPViewModelParams) {
        params.paramsOutputAction.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: OTPViewModelParams.Action) {
        switch action {
        case .success: handleSuccessfulOTP()
        case .error: handleInvalidOTP()
        }
    }

    private func handleSuccessfulOTP() {
    }

    private func handleInvalidOTP() {
    }
}