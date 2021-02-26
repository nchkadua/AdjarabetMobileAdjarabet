//
//  HomeBannerContainerTableViewCellDataProvider.swift
//  Mobile
//
//  Created by Irakli Shelia on 2/22/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public protocol HomeBannerContainerCollectionViewCellDataProvider: HomeBannerContainerComponentViewModel, AppCellDataProvider, CellHeighProvidering { }

public extension HomeBannerContainerCollectionViewCellDataProvider {
    var identifier: String { HomeBannerContainerCollectionViewCell.identifierValue }
}

extension DefaultHomeBannerContainerComponentViewModel: HomeBannerContainerCollectionViewCellDataProvider {
    public func size(for rect: CGRect, safeArea: CGRect, minimumLineSpacing: CGFloat, minimumInteritemSpacing: CGFloat) -> CGSize {
        CGSize(width: rect.width, height: 300)
    }
}
