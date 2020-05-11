//
//  Builder.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/9/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol Builder {
    associatedtype Buildable

    func build() -> Buildable
}
