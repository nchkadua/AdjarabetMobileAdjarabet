//
//  Array+Extension.swift
//  Mobile
//
//  Created by Nika Chkadua on 4/5/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

extension Array where Element: Hashable {
    var uniques: Array {
        var buffer = Array()
        var added = Set<Element>()
        for elem in self {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
}
