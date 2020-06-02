//
//  LoadingCollectionViewCellDataProvider.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 6/1/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol LoadingCollectionViewCellDataProvider: AppCellDataProvider, LoadingComponentViewModel, CellHeighProvidering { }

public extension LoadingCollectionViewCellDataProvider {
    var identifier: String { LoadingCollectionViewCell.identifierValue }
}

extension DefaultLoadingComponentViewModel: LoadingCollectionViewCellDataProvider { }

public extension LoadingCollectionViewCellDataProvider {
    func size(for rect: CGRect, safeArea: CGRect, minimumLineSpacing: CGFloat, minimumInteritemSpacing: CGFloat) -> CGSize {
        CGSize(width: rect.width, height: params.normalizedHeight)
    }
}
