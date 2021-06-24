//
//  DateHeaderCellDataProvider.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/17/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol DateHeaderCellDataProvider: DateHeaderComponentViewModel,
                                                          StaticHeightDataProvider {}
public extension DateHeaderCellDataProvider {
    var identifier: String {DateHeaderCell.identifierValue }
    var height: CGFloat {
        get { 62 }
        set { print(newValue)}
    }
    var isHeightSet: Bool { true }
}

extension DefaultDateHeaderComponentViewModel: DateHeaderCellDataProvider {}
