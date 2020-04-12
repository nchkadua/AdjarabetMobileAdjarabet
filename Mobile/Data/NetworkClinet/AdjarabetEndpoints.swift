//
//  AdjarabetEndpoints.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class AdjarabetEndpoints {
    public static var coreAPIUrl: URL {
        Bundle.main.coreAPIUrl
    }

    public static var webAPIUrl: URL {
        URL(string: "https://webapi.adjarabet.com")!
    }
}
