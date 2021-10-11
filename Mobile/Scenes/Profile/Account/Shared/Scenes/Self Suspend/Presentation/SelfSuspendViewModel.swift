//
//  SelfSuspendViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 11/24/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

protocol SelfSuspendViewModel: BaseViewModel, SelfSuspendViewModelInput, SelfSuspendViewModelOutput {
}

public protocol SelfSuspendViewModelInput {
    func viewDidLoad()
    func selected(duration index: Int)
    func blockButtonDidTap()
}

public protocol SelfSuspendViewModelOutput {
    var action: Observable<SelfSuspendViewModelOutputAction> { get }
    var route: Observable<SelfSuspendViewModelRoute> { get }
}

public enum SelfSuspendViewModelOutputAction {
    case setupDurations(durations: [String])
    case showSuccess
}

public enum SelfSuspendViewModelRoute {
    case openOTP(params: OTPViewModelParams)
}

public class DefaultSelfSuspendViewModel: DefaultBaseViewModel {
    private let actionSubject = PublishSubject<SelfSuspendViewModelOutputAction>()
    private let routeSubject = PublishSubject<SelfSuspendViewModelRoute>()

    @Inject(from: .repositories) private var isEnabledRepo: IsOTPEnabledRepository
    @Inject(from: .repositories) private var suspendRepo: SuspendRepository
    private var selectedDurationIndex: Int = 0
    private let note = "taking a cool off period"
}

extension DefaultSelfSuspendViewModel: SelfSuspendViewModel {
    public var action: Observable<SelfSuspendViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<SelfSuspendViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        actionSubject.onNext(.setupDurations(durations: DurationProvider.durations()))
    }

    public func selected(duration index: Int) {
        selectedDurationIndex = index
    }

    public func blockButtonDidTap() {
        guard let duration = suspendDuration() else { return }
        isEnabledRepo.isEnabled(handler(onSuccessHandler: { [weak self] enabled in
            guard let self = self else { return }
            if enabled {
                self.getOTP()
            } else {
                self.suspend(with: .init(limitPeriod: duration, note: self.note, otp: nil))
            }
        }))
    }

    private func getOTP() {
        let otpParams: OTPViewModelParams = .init(
            vcTitle: R.string.localization.sms_login_page_title.localized(),
            buttonTitle: R.string.localization.sms_approve.localized(),
            username: "",
            otpType: .actionOTP
        )
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
        case .success(let code, _): handle(otp: code)
        case .error: self.show(error: .init()) // TODO: show appropriate error
        }
    }

    private func handle(otp: String?) {
        guard let duration = suspendDuration() else { return }
        suspend(with: .init(limitPeriod: duration, note: note, otp: otp))
    }

    private func suspend(with params: SuspendParams) {
        suspendRepo.suspend(with: params, handler: handler(onSuccessHandler: { [weak self] _ in
            self?.actionSubject.onNext(.showSuccess)
        }))
    }

    private func suspendDuration() -> SuspendDuration? {
        // TODO: Refactor after DurationProvider refactoring
        switch selectedDurationIndex {
        case 0:  return .oneDay
        case 1:  return .twoDays
        case 2:  return .threeDays
        default: return nil
        }
    }
}
