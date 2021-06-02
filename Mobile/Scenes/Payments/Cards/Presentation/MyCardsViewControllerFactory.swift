//
//  MyCardsViewControllerFactory.swift
//  Mobile
//
//  Created by Irakli Shelia on 1/20/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public protocol MyCardsViewControllerFactory {
    func make() -> MyCardsViewController
}

public class DefaultMyCardsViewControllerFactory: MyCardsViewControllerFactory {
    public func make() -> MyCardsViewController {
        let vc = R.storyboard.myCards().instantiate(controller: MyCardsViewController.self)!
        return vc
    }
}
