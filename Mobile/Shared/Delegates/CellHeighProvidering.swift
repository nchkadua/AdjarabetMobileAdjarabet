//
//  CellHeighProvidering.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/21/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol CellHeighProvidering {
    func size(for rect: CGRect, safeArea: CGRect, minimumLineSpacing: CGFloat, minimumInteritemSpacing: CGFloat) -> CGSize
}
