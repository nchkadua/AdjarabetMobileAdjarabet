//
//  SportsViewControllerFactory.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/16/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol SportsViewControllerFactory {
    func make() -> SportsViewController
}

public class DefaultSportsViewControllerFactory: SportsViewControllerFactory {
    public func make() -> SportsViewController {
        R.storyboard.sports().instantiate(controller: SportsViewController.self)!
    }
}
