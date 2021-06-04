//
//  OTPDeliveryChannel.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 6/17/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public enum OTPDeliveryChannel: Int {
    case none = 0 // User does not have High Security activated
    case email = 1
    case sms = 2
    case voiceCall = 4
}
