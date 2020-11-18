//
//  BiometryStorage.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 11/17/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol BiometryStorage: BiometryReadableStorage, BiometryUpdatableStorage { }

public enum BiometryState: Int {
    case on
    case off
}

public protocol BiometryReadableStorage {
    var currentState: BiometryState { get }
    var currentStateObservable: Observable<BiometryState> { get }
}

public protocol BiometryUpdatableStorage {
    func updateCurrentState(with state: BiometryState)
}

public class DefaultBiometryStorage {
    public static let shared = DefaultBiometryStorage()
    private let currentStateSubject = PublishSubject<BiometryState>()

    @ABUserDefaults(Keys.biometry.rawValue, defaultValue: nil)
    private var state: Int? {
        didSet {
            currentStateSubject.onNext(currentState)
        }
    }

    public enum Keys: String {
        case biometry = "com.adjarabet.mobile.storage.biometry"
    }
}

extension DefaultBiometryStorage: BiometryStorage {
    public var currentState: BiometryState {
        if let state = state {
            return BiometryState(rawValue: state)!
        }
        return .off
    }

    public var currentStateObservable: Observable<BiometryState> {
        currentStateSubject.asObservable().distinctUntilChanged()
    }

    public func updateCurrentState(with state: BiometryState) {
        self.state = state.rawValue
    }
}

