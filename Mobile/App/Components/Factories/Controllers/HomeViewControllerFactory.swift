//
//  HomeViewControllerFactory.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/16/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public protocol HomeViewControllerFactory {
    func make() -> HomeViewController
}

public class DefaultHomeViewControllerFactory: HomeViewControllerFactory {
    public func make() -> HomeViewController {
        R.storyboard.home().instantiate(controller: HomeViewController.self)!
    }
}
