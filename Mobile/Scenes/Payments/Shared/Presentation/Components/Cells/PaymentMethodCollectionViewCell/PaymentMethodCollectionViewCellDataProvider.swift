//
//  PaymentMethodCollectionViewCellDataProvider.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/23/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public protocol PaymentMethodCollectionViewCellDataProvider: AppCellDataProvider, AppCellDelegate, PaymentMethodComponentViewModel, CellHeighProvidering { }

public extension PaymentMethodCollectionViewCellDataProvider {
    var identifier: String { PaymentMethodCollectionViewCell.identifierValue }
}

extension DefaultPaymentMethodComponentViewModel: PaymentMethodCollectionViewCellDataProvider { }

public extension PaymentMethodCollectionViewCellDataProvider {
    func size(for rect: CGRect, safeArea: CGRect, minimumLineSpacing: CGFloat, minimumInteritemSpacing: CGFloat) -> CGSize {
        CGSize(width: 110, height: 40)
    }
}
