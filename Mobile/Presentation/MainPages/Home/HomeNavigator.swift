//
//  HomeNavigator.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/15/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class HomeNavigator: Navigator {
    @Inject(from: .factories) public var profileFactory: ProfileFactory
    @Inject(from: .factories)
    private var gameFactory: GameViewControllerFactory

    private weak var viewController: UIViewController?

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public enum Destination {
        case profile
        case game(Game)
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
        switch destination {
        case .profile:
            navigateToProfile(animate: animate)
        case .game(let game):
            navigate2(game: game, animate: animate)
        }
    }

    private func navigateToProfile(animate: Bool) {
        let vc = profileFactory.make()
        let navC = vc.wrapInNavWith(presentationStyle: .fullScreen)
        navC.navigationBar.styleForSecondaryPage()
        viewController?.navigationController?.present(navC, animated: animate, completion: nil)
    }

    private func navigate2(game: Game, animate: Bool) {
        // TODO: Delete after Mobile API will be fixed
        var game = game
        let id2id = [
            "106": "7490" // Zodiac Wheel
            // AStep 1: Map ID
        ]
        if let id = id2id[game.id] {
            game.id = id
        }
        //
        let vc = gameFactory.make(params: .init(game: game))
        let navC = vc.wrapInNavWith(presentationStyle: .fullScreen)
        navC.navigationBar.styleForSecondaryPage()
        viewController?.navigationController?.present(navC, animated: animate, completion: nil)
    }
}
