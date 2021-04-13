//
//  WithdrawVisaNavigator.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 4/5/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

struct WithdrawVisaNavigator {
    @Inject(from: .factories) private var addAccountFactory: AddCardViewControllerFactory

    weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    enum Destination {
        case addAccount(params: AddCardViewModelParams)
    }

    func navigate(to destination: Destination) {
        switch destination {
        case .addAccount(let params):
            navigate2AddCard(with: params)
        }
    }

    private func navigate2AddCard(with params: AddCardViewModelParams) {
        let vc = addAccountFactory.make(params: params)
        let navc = vc.wrapInNavWith(presentationStyle: .automatic)
        navc.navigationBar.styleForPrimaryPage()
        viewController?.navigationController?.present(navc, animated: true, completion: nil)
    }
}
