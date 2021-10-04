//
//  MyBonusesNavigator.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 29.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public class MyBonusesNavigator: Navigator {
	@Inject(from: .factories) public var conditionViewControllerFactory: BonusConditionViewControllerFactory
    private weak var viewController: UIViewController?

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public enum Destination {
		case condition(String, Int?)
		case withoutChildren
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
		switch destination {
		case .condition(let description, let gameId):
			navigateToCondition(description: description, gameId: gameId, animate: animate)
		case .withoutChildren:
			navigateWithoutChildren(animate: animate)
		}
    }

	private func navigateToCondition(description: String, gameId: Int?, animate: Bool) {
		let vc = conditionViewControllerFactory.make(params: .init(description: description, gameId: gameId))
		if let bonusConditionDelegate = viewController as? BonusConditionDelegate {
			vc.delegate = bonusConditionDelegate
		}
		viewController?.navigationController?.present(vc, animated: animate, completion: nil)
	}

	private func navigateWithoutChildren(animate: Bool) {
		self.viewController?.navigationController?.dismiss(animated: true, completion: nil)
	}
}
