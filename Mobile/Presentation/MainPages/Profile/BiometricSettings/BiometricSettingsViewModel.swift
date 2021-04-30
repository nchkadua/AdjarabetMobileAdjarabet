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
    case openSettingsAlert(title: String, message: String? = nil)
}

public class DefaultBiometricSettingsViewModel {
    private let actionSubject = PublishSubject<BiometricSettingsViewModelOutputAction>()
    private let routeSubject = PublishSubject<BiometricSettingsViewModelRoute>()

    private let disposeBag = DisposeBag()
    @Inject private var biometryInfoService: BiometricAuthentication
    @Inject private var biometryStateStorage: BiometryStorage

    private func checkAvailability() {
        if !biometryInfoService.isAvailable {
            biometryStateStorage.updateCurrentState(with: .off)
        }
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
        checkAvailability()
        refreshBiometryStateToggle()
    }

    public func biometryToggleChanged(to isOn: Bool) {
        switch isOn {
        case true:
            if biometryInfoService.isAvailable {
                biometryStateStorage.updateCurrentState(with: .on)
            } else {
                actionSubject.onNext(.updateBiometryStateToggle(false)) // re-set to false
                routeSubject.onNext(.openSettingsAlert(title: R.string.localization.biometric_settings_not_available.localized()))
            }
        case false:
            biometryStateStorage.updateCurrentState(with: .off)
        }
    }

    public func refreshTitleText() {
        actionSubject.onNext(.updateTitleText(R.string.localization.biometric_settings_title.localized().uppercased()))
    }

    public func refreshDescriptionText() {
        let text: String
        switch biometryInfoService.biometryType {
        case .touchID:  text = R.string.localization.biometric_settings_activate_touch_id.localized()
        case .faceID:   text = R.string.localization.biometric_settings_activate_face_id.localized()
        default:        text = R.string.localization.biometric_settings_activate_biometry.localized()
        }
        actionSubject.onNext(.updateDescriptionText(text))
    }

    public func refreshIconImage() {
        let icon: UIImage
        switch biometryInfoService.biometryType {
        case .touchID:  icon = R.image.biometric.touchID()!
        case .faceID:   icon = R.image.biometric.faceID()!
        default:        icon = R.image.biometric.biometry()!
        }
        actionSubject.onNext(.updateIconImage(icon))
    }
}
