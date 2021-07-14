//
//  ResetOptionsViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 14.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol ResetOptionsViewModel: ResetOptionsViewModelInput, ResetOptionsViewModelOutput {
}

public struct ResetOptionsViewModelParams {
}

public protocol ResetOptionsViewModelInput: AnyObject {
    var params: ResetOptionsViewModelParams { get set }
    func viewDidLoad()
    func getResetOptions()
}

public protocol ResetOptionsViewModelOutput {
    var action: Observable<ResetOptionsViewModelOutputAction> { get }
    var route: Observable<ResetOptionsViewModelRoute> { get }
}

public enum ResetOptionsViewModelOutputAction {
    case initialize(AppListDataProvider)
    case didClick(resetType: PasswordResetType)
    case showMessage(message: String)
}

public enum ResetOptionsViewModelRoute {
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
    }

    public func getResetOptions() {
        resetPasswordUseCase.initPasswordReset(username: nil) { result in
            switch result {
            case .success(let entity):
//                let subString = entity.tel?.dropLast(4)
                self.phone = entity.tel
                self.email = entity.email
                self.setupResetOptions(entity.tel ?? "", entity.email ?? "")
            case .failure(let error):
                self.actionSubject.onNext(.showMessage(message: error.localizedDescription))
            }
        }
    }

    private func setupResetOptions(_ phone: String, _ email: String) {
        var dataProviders: AppCellDataProviders = []

        //Phone
        let phoneViewModel = DefaultResetOptionComponentViewModel(params: .init(title: R.string.localization.reset_with_sms.localized(), roundCorners: [.topLeft, .topRight], hidesSeparator: false, isDisabled: phone.isEmpty))
        phoneViewModel.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .didSelect: self?.actionSubject.onNext(.didClick(resetType: .sms))
            default:
                break
            }
        }).disposed(by: self.disposeBag)
        dataProviders.append(phoneViewModel)

        //Email
        let emailViewModel = DefaultResetOptionComponentViewModel(params: .init(title: R.string.localization.reset_with_mail.localized(), roundCorners: [.bottomLeft, .bottomRight], hidesSeparator: true, isDisabled: email.isEmpty))
        emailViewModel.action.subscribe(onNext: { [weak self] action in
            switch action {
            case .didSelect: self?.actionSubject.onNext(.didClick(resetType: .email))
            default:
                break
            }
        }).disposed(by: self.disposeBag)
        dataProviders.append(emailViewModel)

        actionSubject.onNext(.initialize(dataProviders.makeList()))
    }
}

public enum PasswordResetType {
    case sms
    case email
}
