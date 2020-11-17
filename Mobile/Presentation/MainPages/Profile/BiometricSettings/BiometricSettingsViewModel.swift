//
//  BiometricSettingsViewModel.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 11/17/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol BiometricSettingsViewModel: BiometricSettingsViewModelInput, BiometricSettingsViewModelOutput {
}

public protocol BiometricSettingsViewModelInput {
    func viewDidLoad()
    func biometryToggleChanged(to isOn: Bool)
}

public protocol BiometricSettingsViewModelOutput {
    var action: Observable<BiometricSettingsViewModelOutputAction> { get }
    var route: Observable<BiometricSettingsViewModelRoute> { get }
}

public enum BiometricSettingsViewModelOutputAction {
    case updateBiometryStateToggle(Bool)
}

public enum BiometricSettingsViewModelRoute {
}

public class DefaultBiometricSettingsViewModel {
    private let actionSubject = PublishSubject<BiometricSettingsViewModelOutputAction>()
    private let routeSubject = PublishSubject<BiometricSettingsViewModelRoute>()

    private let disposeBag = DisposeBag()
    @Inject private var biometryInfoService: BiometricAuthentication
    @Inject private var biometryStateStorage: BiometryStorage

    private func observeBiometryChange() {
        biometryStateStorage.currentStateObservable.subscribe(onNext: { [weak self] _ in
            self?.biometryDidChange()
        }).disposed(by: disposeBag)
    }

    private func biometryDidChange() {
        refreshBiometryStateToggle()
    }

    private func refreshBiometryStateToggle() {
        let on: Bool
        switch biometryStateStorage.currentState {
        case .on:  on = true
        case .off: on = false
        }
        actionSubject.onNext(.updateBiometryStateToggle(on))
    }
}

extension DefaultBiometricSettingsViewModel: BiometricSettingsViewModel {
    public var action: Observable<BiometricSettingsViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<BiometricSettingsViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        observeBiometryChange()
        refreshBiometryStateToggle()
    }

    public func biometryToggleChanged(to isOn: Bool) {
        switch isOn {
        case true:
            biometryStateStorage.updateCurrentState(with: .on)
        case false:
            biometryStateStorage.updateCurrentState(with: .off)
        }
    }
}
