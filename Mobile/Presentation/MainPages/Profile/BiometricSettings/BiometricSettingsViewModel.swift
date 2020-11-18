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
    func refreshTitleText()
    func refreshDescriptionText()
    func refreshIconImage()
}

public protocol BiometricSettingsViewModelOutput {
    var action: Observable<BiometricSettingsViewModelOutputAction> { get }
    var route: Observable<BiometricSettingsViewModelRoute> { get }
}

public enum BiometricSettingsViewModelOutputAction {
    case updateTitleText(String)
    case updateDescriptionText(String)
    case updateIconImage(UIImage)
    case updateBiometryStateToggle(Bool)
}

public enum BiometricSettingsViewModelRoute {
    case openAlert(title: String, message: String? = nil)
}

public class DefaultBiometricSettingsViewModel {
    private let actionSubject = PublishSubject<BiometricSettingsViewModelOutputAction>()
    private let routeSubject = PublishSubject<BiometricSettingsViewModelRoute>()

    private let disposeBag = DisposeBag()
    @Inject private var biometryInfoService: BiometricAuthentication
    @Inject private var biometryStateStorage: BiometryStorage

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
        refreshBiometryStateToggle()
    }

    public func biometryToggleChanged(to isOn: Bool) {
        switch isOn {
        case true:
            if biometryInfoService.isAvailable {
                biometryStateStorage.updateCurrentState(with: .on)
            } else {
                actionSubject.onNext(.updateBiometryStateToggle(false)) // re-set to false
                routeSubject.onNext(.openAlert(title: "No identities are enrolled.")) // error handling
            }
        case false:
            biometryStateStorage.updateCurrentState(with: .off)
        }
    }

    public func refreshTitleText() {
        actionSubject.onNext(.updateTitleText(R.string.localization.biomatry_authentication_parameters.localized()))
    }

    public func refreshDescriptionText() {
        switch biometryInfoService.biometryType {
        case .touchID:
            let text = R.string.localization.biometric_settings_activate_touch_id.localized()
            actionSubject.onNext(.updateDescriptionText(text))
        case .faceID:
            let text = R.string.localization.biometric_settings_activate_face_id.localized()
            actionSubject.onNext(.updateDescriptionText(text))
        default: break // error handling
        }
    }

    public func refreshIconImage() {
        switch biometryInfoService.biometryType {
        case .touchID:
            let icon = R.image.biometric.touchID()!
            actionSubject.onNext(.updateIconImage(icon))
        case .faceID:
            let icon = R.image.biometric.faceID()!
            actionSubject.onNext(.updateIconImage(icon))
        default: break // error handling
        }
    }
}
