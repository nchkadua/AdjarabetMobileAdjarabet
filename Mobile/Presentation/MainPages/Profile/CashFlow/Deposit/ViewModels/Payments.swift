//
//  Payments.swift
//  Mobile
//
//  Created by Nika Chkadua on 11/1/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class Payment {
    var paymentMethods = ["VISA/MASTERCARD", "EMONEY"]
    var cards = ["123456xxxxxxxx0211", "789123xxxxxxxx0211"]
}

public struct PaymentMethods {
    let methods: [String]
}

public struct PaymentCards {
    let cards: [String]
}
