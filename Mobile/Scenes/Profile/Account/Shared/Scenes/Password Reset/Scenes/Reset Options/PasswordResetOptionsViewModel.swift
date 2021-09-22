//
//  ResetOptionsViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 14.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

protocol ResetOptionsViewModel: BaseViewModel, ResetOptionsViewModelInput, ResetOptionsViewModelOutput {
}

public struct ResetOptionsViewModelParams {
    let showUsernameInput: Bool
    let shouldShowDismissButton: Bool
}

public protocol ResetOptionsViewModelInput: AnyObject {
    var params: ResetOptionsViewModelParams { get set }
    func viewDidLoad()
    func buttonDidClick(_ username: String)
    func clearOptions()
}

public protocol ResetOptionsViewModelOutput {
    var action: Observable<ResetOptionsViewModelOutputAction> { get }
    var route: Observable<ResetOptionsViewModelRoute> { get }
}

public enum ResetOptionsViewModelOutputAction {
    case hideUsernameInput
    case initialize(AppListDataProvider)
    case clearTableview
    case setButton(loading: Bool)
}

public enum ResetOptionsViewModelRoute {
    case navigateToPasswordReset(resetType: PasswordResetType, contact: String, showDismissButton: Bool)
}

public class DefaultResetOptionsViewModel: DefaultBaseViewModel {
    public var params: ResetOptionsViewModelParams
    private let actionSubject = PublishSubject<ResetOptionsViewModelOutputAction>()
    private let routeSubject = PublishSubject<ResetOptionsViewModelRoute>()
    @Inject(from: .useCases) private var resetPasswordUseCase: ResetPasswordUseCase
    //
    private var phone: String?
    private var email: String?

    public init(params: ResetOptionsViewModelParams) {
        self.params = params
    }
}

extension DefaultResetOptionsViewModel: ResetOptionsViewModel {
    public var action: Observable<ResetOptionsViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<ResetOptionsViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        guard params.showUsernameInput else {return}

        actionSubject.onNext(.hideUsernameInput)
        getResetOptions(nil)
    }

    public func buttonDidClick(_ username: String) {
        getResetOptions(username)
    }

    private func getResetOptions(_ username: String?) {
        self.actionSubject.onNext(.setButton(loading: true))
        resetPasswordUseCase.initPasswordReset(username: username) { result in
            defer { self.actionSubject.onNext(.setButton(loading: false)) }
            switch result {
            case .success(let entity):
                self.phone = entity.tel
                self.email = entity.email
                self.setupResetOptions(entity.tel ?? "", entity.email ?? "")
            case .failure(let error):
                self.show(error: error)
            }
        }
    }

    private func setupResetOptions(_ phone: String, _ email: String) {
        var dataProviders: AppCellDataProviders = []

        // Phone
        let phoneViewModel = DefaultResetOptionComponentViewModel(params: .init(title: R.string.localization.reset_with_sms.localized(), roundCorners: [.topLeft, .topRight], hidesSeparator: false, isDisabled: phone.isEmpty))
        phoneViewModel.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .didSelect: self?.routeSubject.onNext(.navigateToPasswordReset(resetType: .sms, contact: self?.phone ?? "", showDismissButton: self?.params.shouldShowDismissButton ?? true))
            default:
                break
            }
        }).disposed(by: self.disposeBag)
        dataProviders.append(phoneViewModel)

        // Email
        let emailViewModel = DefaultResetOptionComponentViewModel(params: .init(title: R.string.localization.reset_with_mail.localized(), roundCorners: [.bottomLeft, .bottomRight], hidesSeparator: true, isDisabled: email.isEmpty))
        emailViewModel.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .didSelect: self?.routeSubject.onNext(.navigateToPasswordReset(resetType: .email, contact: self?.email ?? "", showDismissButton: self?.params.shouldShowDismissButton ?? true))
            default:
                break
            }
        }).disposed(by: self.disposeBag)
        dataProviders.append(emailViewModel)

        actionSubject.onNext(.initialize(dataProviders.makeList()))
    }

    public func clearOptions() {
        actionSubject.onNext(.clearTableview)
    }
}

public enum PasswordResetType: Int {
    case email = 1
    case sms = 2
}
