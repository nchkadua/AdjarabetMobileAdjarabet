//
//  HomeNavigator.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/15/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class HomeNavigator: Navigator {
    @Inject(from: .factories) public var profileFactory: ProfileFactory
    @Inject(from: .factories) public var gameFactory: GameViewControllerFactory

    private weak var viewController: UIViewController?

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public enum Destination {
        case profile
        case game
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
        switch destination {
        case .profile:
            navigateToProfile(animate: animate)
        case .game:
            navigatetoGame(animate: animate)
        }
    }
    
    private func navigateToProfile(animate: Bool) {
        let vc = profileFactory.make()
        let navC = vc.wrapInNavWith(presentationStyle: .fullScreen)
        navC.navigationBar.styleForSecondaryPage()

        viewController?.navigationController?.present(navC, animated: animate, completion: nil)
    }
    
    private func navigatetoGame(animate: Bool) {
        let vc = gameFactory.make(params: .init())
        let navC = vc.wrapInNavWith(presentationStyle: .fullScreen)
        navC.navigationBar.styleForSecondaryPage()

        viewController?.navigationController?.present(navC, animated: animate, completion: nil)
    }
}
