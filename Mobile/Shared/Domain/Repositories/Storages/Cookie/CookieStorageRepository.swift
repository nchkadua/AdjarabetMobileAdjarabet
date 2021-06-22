//
//  CookieStorageRepository.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 6/16/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol CookieStorageRepository {
    func update(headerFields: [String: String])
}

public class DefaultCookieStorageRepository: CookieStorageRepository {
    public func update(headerFields: [String: String]) {
        guard let url = URL(string: AppConstant.coreOriginDomain) else {return}

        HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: url).forEach {
            HTTPCookieStorage.sharedCookieStorage(forGroupContainerIdentifier: AppConstant.cookieAppGorup).setCookie($0)
        }
    }
}
