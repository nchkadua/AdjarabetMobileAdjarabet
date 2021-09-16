//
//  TermsAndConditionsTableViewCellDataProvider.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 02.08.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public protocol TermsAndConditionsTableViewCellDataProvider: TermsAndConditionsComponentViewModel, StaticHeightDataProvider, AppCellDelegate { }

public extension TermsAndConditionsTableViewCellDataProvider {
    var identifier: String { TermsAndConditionsTableViewCell.identifierValue }
    var height: CGFloat {
        get { 64 }
        set { print(newValue) }
    }
    var isHeightSet: Bool { false }
}

extension DefaultTermsAndConditionsComponentViewModel: TermsAndConditionsTableViewCellDataProvider { }
