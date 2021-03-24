//
//  UFCTransactionEntities.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 3/16/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

/**
 Service Types of UFC
 */
public enum UFCServiceType {
    case regular
    case vip

    var description: Description {
        switch self {
        case .regular: return .init(serviceId: 1030, serviceName: "ufc")
        case .vip:     return .init(serviceId: 1115, serviceName: "ufc_vip")
        }
    }

    struct Description {
        let serviceId: Int
        let serviceName: String
    }
}

/**
 Parameters Factory Helper
 */
struct UFCTransactionParamsFactory {
    func make (
        serviceType: UFCServiceType,
        amount: Double,
        accountId: Int64? = nil,   // card ID
        saveAccount: Bool = false, // add to cards or not
        session: String? = nil
    ) -> UFCTransactionParams {
        let serviceDescription = serviceType.description
        return .init(providerId: "c47e7151-a66f-4430-9c2d-adb656c14bb6",
                     serviceId: serviceDescription.serviceId,
                     serviceName: serviceDescription.serviceName,
                     amount: amount,
                     saveForRecurring: saveAccount ? 1 : 0,
                     accountId: accountId,
                     session: session)
    }
}

// MARK: - UFCServiceType Constructor
extension UFCServiceType {
    init?(paymentMethodType: PaymentMethodType) {
        switch paymentMethodType {
        case .tbcVip: self = .vip
        case .tbcRegular: self = .regular
        default:
            return nil
        }
    }
}

// MARK: - Payment Methods
public enum PaymentMethodType {
    case tbcVip
    case tbcRegular
    case eMoney
    case aPay
}

public extension PaymentMethodType {
    init?(flowId: String) {
        switch flowId {
        case "deposite_tbc_ufc_vip": self = .tbcVip
        case "deposite_tbc_ufc_regular": self = .tbcRegular
        case "deposite_emoney": self = .eMoney
        case "deposit_applepay": self = .aPay
        default:
            return nil
        }
    }
}
