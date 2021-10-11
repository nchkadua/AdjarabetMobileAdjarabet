//
//  TermsAndConditionsTableViewCellDataProvider.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 02.08.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public protocol TermsAndConditionsTableViewCellDataProvider: TermsAndConditionsComponentViewModel, AppCellDataProvider, AppCellDelegate { }

public extension TermsAndConditionsTableViewCellDataProvider {
    var identifier: String { TermsAndConditionsTableViewCell.identifierValue }
}

extension DefaultTermsAndConditionsComponentViewModel: TermsAndConditionsTableViewCellDataProvider { }
