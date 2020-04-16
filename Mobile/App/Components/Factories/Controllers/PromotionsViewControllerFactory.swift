//
//  PromotionsViewControllerFactory.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/16/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol PromotionsViewControllerFactory {
    func make() -> PromotionsViewController
}

public class DefaultPromotionsViewControllerFactory: PromotionsViewControllerFactory {
    public func make() -> PromotionsViewController {
        R.storyboard.promotions().instantiate(controller: PromotionsViewController.self)!
    }
}
