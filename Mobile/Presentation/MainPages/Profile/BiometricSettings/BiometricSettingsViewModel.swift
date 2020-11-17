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
}

public protocol BiometricSettingsViewModelOutput {
    var action: Observable<BiometricSettingsViewModelOutputAction> { get }
    var route: Observable<BiometricSettingsViewModelRoute> { get }
}

public enum BiometricSettingsViewModelOutputAction {
}

public enum BiometricSettingsViewModelRoute {
}

public class DefaultBiometricSettingsViewModel {
    private let actionSubject = PublishSubject<BiometricSettingsViewModelOutputAction>()
    private let routeSubject = PublishSubject<BiometricSettingsViewModelRoute>()
}

extension DefaultBiometricSettingsViewModel: BiometricSettingsViewModel {
    public var action: Observable<BiometricSettingsViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<BiometricSettingsViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
    }
}
