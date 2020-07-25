//
//  PageDescription.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/31/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public struct PageDescription {
    public var current: Int = 1
    public var hasMore: Bool = true
    public var itemsPerPage: Int = 20

    public var nextPage: Int {
        guard hasMore else { return current }
        return current + 1
    }

    public mutating func reset() {
        current = 1
        hasMore = true
    }

    public mutating func setNextPage() {
        current += 1
    }

    public mutating func configureHasMore(forNumberOfItems numberOfItems: Int) {
        hasMore = itemsPerPage <= numberOfItems
    }
}
