//
//  VideoCardTableViewCellDataProvider.swift
//  Mobile
//
//  Created by Irakli Shelia on 1/21/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public protocol VideoCardTableViewCellDataProvider: VideoCardComponentViewModel, StaticHeightDataProvider { }

public extension VideoCardTableViewCellDataProvider {
    var identifier: String { VideoCardTableViewCell.identifierValue }
    var height: CGFloat {
        get { 220 }
        set { print(newValue) }
    }
    var isHeightSet: Bool { true }
}

extension DefaultVideoCardComponentViewModel: VideoCardTableViewCellDataProvider { }
