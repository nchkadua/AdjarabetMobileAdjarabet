//
//  MyCardsCreditCard.swift
//  Mobile
//
//  Created by Irakli Shelia on 1/20/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public enum MyCard: MyCardable {
    public enum Issuer {
        case visa
        case masterCard
        case other
    }

    public enum Bank {
        case bog
        case tbc
        case other
    }
    case card(issuer: Issuer, bank: Bank, number: String, dateAdded: Date)

    var issuer: Issuer {
        switch self {
        case .card(let issuer, _, _, _):
            return issuer
        }
    }

    var bank: Bank {
        switch self {
        case .card(_, let bank, _, _):
            return bank
        }
    }

    var number: String {
        switch self {
        case .card(_, _, let number, _):
            return number
        }
    }

    var dateAdded: Date {
        switch self {
        case .card(_, _, _, let date):
            return date
        }
    }
}
