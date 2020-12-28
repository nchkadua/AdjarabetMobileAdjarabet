//
//  AdjarabetWebAPIServices.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol AdjarabetWebAPIServices: AdjarabetWebAPIUserLoggedInServices { }

public protocol AdjarabetWebAPIUserLoggedInServices {
    func userLoggedIn<T: Codable>(userId: Int, domain: String, sessionId: String, completion: @escaping (Result<T, Error>) -> Void)
}
