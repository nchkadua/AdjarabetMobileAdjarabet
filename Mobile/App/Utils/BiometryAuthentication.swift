//
//  BiometricAuthentication.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import LocalAuthentication

public protocol BiometricAuthentication {
    var isAvailable: Bool { get }
    var biometryType: LABiometryType { get }
    var icon: UIImage? { get }
    var title: String? { get }
    func authenticate(completion: @escaping (Result<Void, Error>) -> Void)
}

public class DefaultBiometricAuthentication: BiometricAuthentication {
    private var context = LAContext()

    public var isAvailable: Bool {
        biometryType != .none
    }

    public var biometryType: LABiometryType {
        var error: NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .none
        }

        return context.biometryType
    }

    public func authenticate(completion: @escaping (Result<Void, Error>) -> Void) {
        var error: NSError?
        let reasonString = "Easy login"

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            completion(.failure(error ?? NSError()))
            return
        }

        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { success, evalPolicyError in
            DispatchQueue.main.async {
                if success {
                    completion(.success(()))
                } else {
                    completion(.failure(evalPolicyError ?? NSError()))
                }
            }

            self.context = LAContext()
        })
    }

    public var icon: UIImage? {
        switch biometryType {
        case .faceID:       return R.image.shared.faceID()
        case .touchID:      return R.image.shared.faceID()
        case .none:         return nil
        @unknown default:   return nil
        }
    }

    public var title: String? {
        switch biometryType {
        case .faceID:       return "Log in with face ID"
        case .touchID:      return "Log in with touch ID"
        case .none:         return nil
        @unknown default:   return nil
        }
    }
}
