//
//  AdjarabetEndpoints.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class AdjarabetEndpoints {
    public static var coreAPIUrl: String {
        Bundle.main.coreAPIUrl
    }

    public static var mobileAPIUrl: URL {
        Bundle.main.mobileAPIUrl
    }

    public static var webAPIUrl: URL {
        URL(string: "https://webapi.adjarabet.com")!
    }
}
