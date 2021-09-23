//
//  FAQCategoriesNavigator.swift
//  Mobile
//
//  Created by Nika Chkadua on 20.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public class FAQCategoriesNavigator: Navigator {
    @Inject(from: .factories) public var questionsViewControllerFactory: FAQQuestionsViewControllerFactory

    private weak var viewController: UIViewController?

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public enum Destination {
        case questions(questions: [FAQQuestion], shouldShowDismissButton: Bool)
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
        switch destination {
        case .questions(let questions, let shouldShowDismissButton): navigateToQuestions(questions: questions, showDismissButton: shouldShowDismissButton, animate: animate)
        }
    }

    private func navigateToQuestions(questions: [FAQQuestion], showDismissButton: Bool, animate: Bool) {
        let vc = questionsViewControllerFactory.make(params: .init(questions: questions, showDismissButton: showDismissButton))
        viewController?.navigationController?.pushViewController(vc, animated: animate)
    }
}
