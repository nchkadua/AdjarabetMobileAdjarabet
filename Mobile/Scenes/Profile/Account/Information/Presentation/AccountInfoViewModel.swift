//
//  AccountInfoViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/21/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

protocol AccountInfoViewModel: BaseViewModel,
                               AccountInfoViewModelInput,
                               AccountInfoViewModelOutput { }

protocol AccountInfoViewModelInput {
    func viewDidLoad()
    func changeAddressTapped()
}

protocol AccountInfoViewModelOutput {
    var action: Observable<AccountInfoViewModelOutputAction> { get }
    var route: Observable<AccountInfoViewModelRoute> { get }
}

enum AccountInfoViewModelOutputAction {
    case setupWithAccountInfoModel(_ accountInfoModel: AccountInfoModel)
    case setAndBindCommunicationLanguage(_ viewModel: CommunicationLanguageComponentViewModel)
    case setPersonalID(id: String)
    case setAddress(address: String)
}

enum AccountInfoViewModelRoute {
    case otp(params: OTPViewModelParams)
    case addressChange(params: AddressChangeViewModelParams)
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

    func changeAddressTapped() {
        let params: AddressChangeViewModelParams = .init()
        subscribeTo(params)
        routeSubject.onNext(.addressChange(params: params))
    }

    private func subscribeTo(_ params: AddressChangeViewModelParams) {
        params.paramsOutputAction.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: AddressChangeViewModelParams.Action) {
        switch action {
        case .success(let newAddress):
            actionSubject.onNext(.setAddress(address: newAddress))
        }
    }

    private func refreshUserInfo() {
        fetchUserInfo()
        fetchUserLang()

        userInfoRepo.getIDDocuments { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let entity): self.actionSubject.onNext(.setPersonalID(id: entity.idDocuments.first?.personalID ?? "-----------"))
            case .failure(let error): self.show(error: error)
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
                self.show(error: error)
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
                self.show(error: error)
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
                self.show(error: error)
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
                self.show(error: .init()) // TODO: show appropriate error
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
                self.show(error: error)
            }
        }
    }
}
