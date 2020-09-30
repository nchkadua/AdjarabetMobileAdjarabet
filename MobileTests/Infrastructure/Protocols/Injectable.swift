//
//  Injectable.swift
//  MobileTests
//
//  Created by Shota Ioramashvili on 10/1/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation
@testable import Mobile

extension Mirror {
    fileprivate func inject<T>(testable: T) {
        for child in self.children {
            if let injectable = child.value as? Inject<T> {
                injectable.storage = testable
            }
        }
    }
}

protocol Injectable {
    func inject<T>(testable: T)
}

extension Injectable {
    func inject<T>(testable: T) {
        Mirror(reflecting: self).inject(testable: testable)
    }
}
