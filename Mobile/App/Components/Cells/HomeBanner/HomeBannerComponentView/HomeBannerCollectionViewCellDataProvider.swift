//
//  HomeBannerTableViewCellDataProvider.swift
//  Mobile
//
//  Created by Irakli Shelia on 2/22/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public protocol HomeBannerCollectionViewCellDataProvider: HomeBannerComponentViewModel, AppCellDataProvider, CellHeighProvidering { }

public extension HomeBannerCollectionViewCellDataProvider {
    var identifier: String { HomeBannerCollectionViewCell.identifierValue }
}

extension DefaultHomeBannerComponentViewModel: HomeBannerCollectionViewCellDataProvider {
    public func size(for rect: CGRect, safeArea: CGRect, minimumLineSpacing: CGFloat, minimumInteritemSpacing: CGFloat) -> CGSize {
        CGSize(width: rect.width, height: 300)
    }
}
