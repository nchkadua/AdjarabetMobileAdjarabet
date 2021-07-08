//
//  AppDeletableCellDelegate.swift
//  Mobile
//
//  Created by Nika Chkadua on 11/3/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol AppDeletableCellDelegate: AnyObject {
    func didDelete(at indexPath: IndexPath)
}

public protocol AppRedrawableCellDelegate: AnyObject {
    func redraw(at indexPath: IndexPath)
}
