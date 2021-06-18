//
//  OTPViewModel.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/13/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol OTPViewModel: OTPViewModelInput, OTPViewModelOutput {
}

public struct OTPViewModelParams {
    public enum Action {
        case success(otp: String)
        case error
    }
    public let paramsOutputAction = PublishSubject<Action>()
    public let vcTitle: String
    public let buttonTitle: String
    public let showDismissButton: Bool
    public let username: String
    public let otpType: OTPType

    public init(vcTitle: String = "", buttonTitle: String = "", showDismissButton: Bool = true, username: String = "", otpType: OTPType = .loginOTP) {
        self.vcTitle = vcTitle
        self.buttonTitle = buttonTitle
        self.showDismissButton = showDismissButton
        self.username = username
        self.otpType = otpType
    }
}

public protocol OTPViewModelInput: AnyObject {
    var params: OTPViewModelParams { get set }
    func viewDidLoad()
    func textDidChange(to text: String?)
    func shouldChangeCharacters(for text: String) -> Bool
    func shoudEnableLoginButton(fot text: String?) -> Bool
    func resendSMS()
    func accept(code: String)
    func restartTimer()
    func didBindToTimer()
}

public protocol OTPViewModelOutput {
    var action: Observable<OTPViewModelOutputAction> { get }
    var route: Observable<OTPViewModelRoute> { get }
}

public enum OTPViewModelOutputAction {
    case setNavigationItems(_ title: String, showDismissButton: Bool)
    case setButtonTitle(_ title: String)
    case setSMSInputViewNumberOfItems(Int)
    case setSMSCodeInputView(text: [String?])
    case setResendSMSButton(isLoading: Bool)
    case setLoginButton(isLoading: Bool)
    case bindToTimer(timerViewModel: TimerComponentViewModel)
}

public enum OTPViewModelRoute {
    case openMainTabBar
    case showErrorMessage(title: String, message: String? = nil)
    case showSuccessMessage
    case dismiss
}

public class DefaultOTPViewModel {
    public var params: OTPViewModelParams
    private let actionSubject = PublishSubject<OTPViewModelOutputAction>()
    private let routeSubject = PublishSubject<OTPViewModelRoute>()
    private let smsCodeLength = 4

    @Inject(from: .repositories) private var actionTOPRepo: ActionOTPRepository
    @Inject(from: .useCases) private var OTPUseCase: OTPUseCase
    @Inject(from: .useCases) private var smsCodeUseCase: SMSCodeUseCase
    @Inject(from: .viewModels) private var timerViewModel: TimerComponentViewModel
    @Inject private var userSession: UserSessionServices

    public init(params: OTPViewModelParams) {
        self.params = params
    }
}

extension DefaultOTPViewModel: OTPViewModel {
    public var action: Observable<OTPViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<OTPViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        actionSubject.onNext(.setNavigationItems(params.vcTitle, showDismissButton: params.showDismissButton))
        actionSubject.onNext(.setButtonTitle(params.buttonTitle))
        actionSubject.onNext(.setSMSInputViewNumberOfItems(smsCodeLength))
        actionSubject.onNext(.bindToTimer(timerViewModel: timerViewModel))

        switch params.otpType {
        case .loginOTP: getOTP()
        case .actionOTP: getActionOTP()
        case .none: return
        }
    }

    public func didBindToTimer() {
        timerViewModel.start(from: 30)
    }

    public func restartTimer() {
        timerViewModel.start(from: 30)
    }

    public func textDidChange(to text: String?) {
        let text = text ?? ""

        let texts = (0..<smsCodeLength).map { index in
            index < text.count ? String(text[text.index(text.startIndex, offsetBy: index)]) : nil
        }

        actionSubject.onNext(.setSMSCodeInputView(text: texts))
    }

    public func shouldChangeCharacters(for text: String) -> Bool {
        text.count <= smsCodeLength
    }

    public func shoudEnableLoginButton(fot text: String?) -> Bool {
        (text ?? "").count == smsCodeLength
    }

    public func resendSMS() {
        actionSubject.onNext(.setResendSMSButton(isLoading: true))
        getOTP()
    }

    private func getOTP() {
        let username = params.username.isEmpty ? userSession.username : params.username
        print("asdadasds ", username)
        smsCodeUseCase.execute(username: username ?? "") { [weak self] result in
            defer { self?.actionSubject.onNext(.setResendSMSButton(isLoading: false)) }
            switch result {
            case .success: print(result)
            case .failure(let error): self?.routeSubject.onNext(.showErrorMessage(title: error.localizedDescription))
            }
        }
    }

    private func getActionOTP() {
        actionTOPRepo.actionOTP { result in
            switch result {
            case .success: print(result)
            case .failure(let error): self.routeSubject.onNext(.showErrorMessage(title: error.localizedDescription))
            }
        }
    }

    public func accept(code: String) {
        switch params.otpType {
        case .loginOTP: login(code: code)
        case .actionOTP:
            params.paramsOutputAction.onNext(.success(otp: code))
            routeSubject.onNext(.dismiss)
        case .none:
            break
        }
    }

    private func login(code: String) {
        actionSubject.onNext(.setLoginButton(isLoading: true))

        let username = params.username.isEmpty ? userSession.username : params.username
        OTPUseCase.execute(username: username ?? "", code: code) { [weak self] result in
            defer { self?.actionSubject.onNext(.setLoginButton(isLoading: false)) }
            switch result {
            case .success:
                self?.routeSubject.onNext(.showSuccessMessage)
                self?.routeSubject.onNext(.openMainTabBar)
            case .failure(let error):
                self?.routeSubject.onNext(.showErrorMessage(title: error.localizedDescription))
            }
        }
    }
}

public enum OTPType {
    case loginOTP
    case actionOTP
    case none
}
