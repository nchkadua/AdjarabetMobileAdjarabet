//
//  SMSLoginNavigator.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/13/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class SMSLoginNavigator: Navigator {
    private weak var viewController: UIViewController?

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public enum Destination {
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
    }
}

public protocol SMSLoginFactory {
    func make(params: SMSLoginViewModelParams) -> SMSLoginViewController
}

public class DefaultSMSLoginFactory: SMSLoginFactory {
    public func make(params: SMSLoginViewModelParams) -> SMSLoginViewController {
        let vc = R.storyboard.smsLogin().instantiateInitial(controller: SMSLoginViewController.self)!
        vc.viewModel = DefaultSMSLoginViewModel(params: params)
        return vc
    }
}
