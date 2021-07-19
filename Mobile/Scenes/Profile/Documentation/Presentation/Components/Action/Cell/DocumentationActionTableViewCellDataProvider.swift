//
//  DocumentationActionTableViewCellDataProvider.swift
//  Mobile
//
//  Created by Nika Chkadua on 06.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public protocol DocumentationActionTableViewCellDataProvider: AppCellDelegate, DocumentationActionComponentViewModel, StaticHeightDataProvider { }

public extension DocumentationActionTableViewCellDataProvider {
    var identifier: String { DocumentationActionTableViewCell.identifierValue }
    var height: CGFloat {
        get { 54 }
        set { print(newValue) }
    }
    var isHeightSet: Bool { true }
}

extension DefaultDocumentationActionComponentViewModel: DocumentationActionTableViewCellDataProvider { }
