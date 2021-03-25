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
 UFCServiceType Payment Account Entity Initialized
 */
extension UFCServiceType {
    init?(account: PaymentAccountEntity) {
        // FIXME: temporary logic
        guard let providerName = account.providerName
        else { return nil }
        if providerName.lowercased().contains("vip") {
            self = .vip
        } else {
            self = .regular
        }
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
