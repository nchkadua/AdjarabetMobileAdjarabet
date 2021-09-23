//
//  FAQQuestionsNavigator.swift
//  Mobile
//
//  Created by Nika Chkadua on 20.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public class FAQQuestionsNavigator: Navigator {
    @Inject(from: .factories) public var answersFactory: FAQAnswersViewControllerFactory

    private weak var viewController: UIViewController?

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public enum Destination {
        case answers(shouldShowDismissButton: Bool, question: FAQQuestion)
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
        switch destination {
        case .answers(let shouldShowDismissButton, let question): navigateToAnswers(showDismissButton: shouldShowDismissButton, question: question, animate: animate)
        }
    }

    private func navigateToAnswers(showDismissButton: Bool, question: FAQQuestion, animate: Bool) {
        let vc = answersFactory.make(params: .init(showDismissButton: showDismissButton, question: question))
        viewController?.navigationController?.pushViewController(vc, animated: animate)
    }
}
