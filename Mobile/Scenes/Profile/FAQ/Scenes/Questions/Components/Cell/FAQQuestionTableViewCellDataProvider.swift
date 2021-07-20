//
//  FAQQuestionTableViewCellDataProvider.swift
//  Mobile
//
//  Created by Nika Chkadua on 20.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public protocol FAQQuestionTableViewCellDataProvider: AppCellDelegate, FAQQuestionComponentViewModel, StaticHeightDataProvider { }

public extension FAQQuestionTableViewCellDataProvider {
    var identifier: String { FAQQuestionTableViewCell.identifierValue }
    var height: CGFloat {
        get { 70 }
        set { print(newValue) }
    }
    var isHeightSet: Bool { true }
}

extension DefaultFAQQuestionComponentViewModel: FAQQuestionTableViewCellDataProvider { }
