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
            "63": "7393",   // Amazing Amazonia
            "105": "7394",  // Amazons' Battle
            "6605": "7395", // Ancient Dynasty
            "107": "7396",  // Aztec Glory
            "82": "7390",   // Age of Troy
            "114": "7400",  // Burning Hot
            "6259": "7401", // Burning Hot 6 Reels
            "64": "7397",   // Blue Heart
            "73": "7398",   // Book of Magic
         // "": "",         // Brilliant Dice // TODO: not-in: Excel, Game List
            "56": "7405",   // Circus Briliant
         // "": "",         // Caramel Dice  // TODO: not-in: Excel, Game List
            "110": "7402",  // Caramel Hot
            "58": "7403",   // Casino Mania
            "89": "7409",   // Dice And Roll
         // "": "",         // Egypt Dice    // TODO: not-in: Excel, Game List
            "83": "7417",   // Extremely Hot
            "1787": "7388", // 81 Wins
            "6996": "9675", // Emperor's Palace // FIXME: 500 Server Error
            "84": "7415",   // Egypt sky
            "6458": "7386", // 50 Amazon's Battle
            "157": "7375",  // 40 Burning Hot
            "6045": "7376", // 40 Burning Hot 6 reels
            "519": "7382",  // 5 Burning Heart
            "226": "7421",  // Forest Band
            "95": "7383",   // 5 Dazzling Hot
            "4921": "7384", // 5 Great Star
            "6471": "7420", // Flaming Hot Extreme
            "94": "7419",   // Flaming Hot
            "4626": "7377", // 40 Hot & Cash
            "59": "7387",   // 50 Horses
            "573": "7378",  // 40 Lucky King
            "558": "7379",  // 40 Mega Clover
         // "": "",         // 40 Super Dice  // TODO: not-in: Excel, Game List
            "113": "7380",  // 40 Super Hot
            "61": "7432",   // Great Empire
            "96": "7476",   // The Great Egypt
            "72": "7429",   // Grace Of Cleopatra
            "90": "7426",   // Game Of Luck
            "5144": "7430", // Great 27
            "534": "7361",  // 100 Burning Hot
            "87": "7362",   // 100 Cats
            "60": "7434",   // Hot & Cash
            "111": "7363",  // 100 Super Hot
            "71": "7436",   // Inca Gold II
            "6694": "9674", // Ice Valley // FIXME: 500 Server Error
            "70": "7441",   // Kashmir Gold
            "6969": "9411", // Knight's Heart
            "81": "7445",   // Lucky & Wild
            "92": "7447",   // Lucky Hot
            "78": "7449",   // Majestic Forest
            "93": "7453",   // More Lucky & Wild
            "101": "7448",  // Magellan
            "7053": "9710", // Mythical Treasure // FIXME: 500 Server Error
            "85": "7455",   // Oil Company II
            "88": "7456",   // Olympus Glory
            "7030": "9412", // Pin Up Queens
            "74": "7457",   // Penguin Style
            "109": "7458",  // Queen of Rio // FIXME: 404 on localhost
            "7081": "9643", // Retro Cabaret // FIXME: 500 Server Error
         // "": "",         // Royal Gardens // TODO: not-in: Excel, Game List
            "6633": "7459", // Rainbow Luck
            "65": "7463",   // Rise Of RA
            "68": "7465",   // Royal Secrets
            "327": "7461",  // Retro Style
            "108": "7462",  // Rich World
         // "": "",         // SBJSlot?      // TODO: Ask for EGT
            "66": "7468",   // Shining Crown
            "76": "7472",   // Supreme Hot
            "341": "7467",  // Secrets of Alchemy
            "351": "7469",  // Spanish Passion
            "359": "7471",  // Super 20
            "155": "7365",  // 20 Burning Hot
            "119": "7360",  // 10 Burning Heart
            "580": "7366",  // 20 Dazzling Hot
            "67": "7367",   // 20 Diamonds
            "80": "7364",   // 2 Dragons
         // "7137": "",     // 20 Golden Coins // TODO: not-in: Excel
            "5095": "7368", // 20 Hot Blast
            "4807": "7369", // 20 Joker Reels
            "102": "7372",  // 30 Spicy Fruits
         // "": "",         // TSHJSlot?       // TODO: Ask for EGT
            "370": "7478",  // The Story of Alexander
         // "7117": "",     // The Story of Alexander 2  // TODO: not-in: Excel
            "5056": "7371", // 27 Wins
            "75": "7479",   // The White Wolf
            "91": "7481",   // Ultimate Hot
            "69": "7484",   // Versailles Gold
            "6308": "7482", // Vampire Night
            "6195": "7486", // Volcano Wealth
            "120": "7489",  // Wonderheart
            "100": "7416",  // Extra Stars
            "106": "7490"   // Zodiac Wheel
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
