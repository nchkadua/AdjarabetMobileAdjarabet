//
//  RecentlyPlayedCollectionViewCellDataProvider.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/21/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol RecentlyPlayedCollectionViewCellDataProvider: AppCellDataProvider, RecentlyPlayedComponentViewModel, CellHeighProvidering { }

public extension RecentlyPlayedCollectionViewCellDataProvider {
    var identifier: String { RecentlyPlayedCollectionViewCell.identifierValue }
}

extension DefaultRecentlyPlayedComponentViewModel: RecentlyPlayedCollectionViewCellDataProvider { }

public extension RecentlyPlayedCollectionViewCellDataProvider {
    func size(for rect: CGRect, safeArea: CGRect, minimumLineSpacing: CGFloat, minimumInteritemSpacing: CGFloat) -> CGSize {
        CGSize(width: rect.width, height: params.isVisible ? 248 : 0)
    }
}
