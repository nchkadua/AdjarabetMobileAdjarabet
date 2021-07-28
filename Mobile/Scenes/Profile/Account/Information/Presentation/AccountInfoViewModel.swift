//
//  AccountInfoViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/21/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

protocol AccountInfoViewModel: AccountInfoViewModelInput,
                               AccountInfoViewModelOutput { }

protocol AccountInfoViewModelInput {
    func viewDidLoad()
}

protocol AccountInfoViewModelOutput {
    var action: Observable<AccountInfoViewModelOutputAction> { get }
    var route: Observable<AccountInfoViewModelRoute> { get }
}

enum AccountInfoViewModelOutputAction {
    case setupWithAccountInfoModel(_ accountInfoModel: AccountInfoModel)
    case setAndBindCommunicationLanguage(_ viewModel: CommunicationLanguageComponentViewModel)
    case showError(_ error: ABError)
}

enum AccountInfoViewModelRoute {
    case otp(params: OTPViewModelParams)
}

class DefaultAccountInfoViewModel: DefaultBaseViewModel {
    private let actionSubject = PublishSubject<AccountInfoViewModelOutputAction>()
    private let routeSubject = PublishSubject<AccountInfoViewModelRoute>()

    @Inject(from: .repositories) private var userInfoRepo: UserInfoReadableRepository
    @Inject(from: .repositories) private var langRepo: CommunicationLanguageRepository
    @Inject(from: .repositories) private var actionOTPRepo: IsOTPEnabledRepository
}

extension DefaultAccountInfoViewModel: AccountInfoViewModel {
    var action: Observable<AccountInfoViewModelOutputAction> { actionSubject.asObserver() }
    var route: Observable<AccountInfoViewModelRoute> { routeSubject.asObserver() }

    func viewDidLoad() {
        refreshUserInfo()
    }

    private func refreshUserInfo() {
        fetchUserInfo()
        fetchUserLang()

        userInfoRepo.getIDDocuments { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let entity): print("Asdasda ", entity.idDocuments)
            case .failure(let error): self.actionSubject.onNext(.showError(error))
            }
        }
    }

    private func fetchUserInfo() {
        userInfoRepo.currentUserInfo(params: .init()) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let userInfo):
                let accountInfoModel = AccountInfoModel.create(from: userInfo)
                self.actionSubject.onNext(.setupWithAccountInfoModel(accountInfoModel))
            case .failure(let error):
                self.actionSubject.onNext(.showError(error))
            }
        }
    }

    private func fetchUserLang() {
        langRepo.getUserLang { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let language):
                let viewModel = DefaultCommunicationLanguageComponentViewModel(params: .init(language: language))
                viewModel.action.subscribe(onNext: { [weak self] action in
                    guard let self = self else { return }
                    switch action {
                    case .doneTapped(let selectedLanguage):
                        self.changeLanguage(selected: selectedLanguage)
                    default:
                        break
                    }
                }).disposed(by: self.disposeBag)
                self.actionSubject.onNext(.setAndBindCommunicationLanguage(viewModel))
            case .failure(let error):
                self.actionSubject.onNext(.showError(error))
            }
        }
    }

    private func changeLanguage(selected language: CommunicationLanguageEntity) {
        actionOTPRepo.isEnabled { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let isEnabled):
                if isEnabled {
                    self.requireOtp(selected: language)
                } else {
                    self.changeLanguage(language: language)
                }
            case .failure(let error):
                self.actionSubject.onNext(.showError(error))
            }
        }
    }

    private func requireOtp(selected language: CommunicationLanguageEntity) {
        let params = OTPViewModelParams(
            vcTitle: R.string.localization.sms_login_page_title.localized(),
            buttonTitle: R.string.localization.sms_approve.localized(),
            username: "", // TODO: Nika sure?
            otpType: .actionOTP
        )

        params.paramsOutputAction.subscribe(onNext: { [weak self] action in
            guard let self = self else { return }
            switch action {
            case .success(let code, _):
                self.changeLanguage(language: language, otpCode: code)
            case .error:
                self.actionSubject.onNext(.showError(.default))
            }
        }).disposed(by: disposeBag)

        routeSubject.onNext(.otp(params: params))
    }

    private func changeLanguage(language: CommunicationLanguageEntity, otpCode: String? = nil) {
        langRepo.changeUserLang(with: language, code: otpCode) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                {}() // do nothing
            case .failure(let error):
                self.actionSubject.onNext(.showError(error))
            }
        }
    }
}
