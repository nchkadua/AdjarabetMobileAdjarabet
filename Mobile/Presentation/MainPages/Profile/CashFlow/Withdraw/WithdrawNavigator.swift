//
//  WithdrawNavigator.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/28/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

struct WithdrawNavigator {
    @Inject(from: .factories) private var addAccountFactory: AddCardViewControllerFactory

    private weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    enum Destination {
        case addAccount
    }

    func navigate(to destination: Destination) {
        switch destination {
        case .addAccount: navigate2AddAccount()
        }
    }

    private func navigate2AddAccount() {
        let vc = addAccountFactory.make(params: .init())
        let navc = vc.wrapInNavWith(presentationStyle: .automatic)
        navc.navigationBar.styleForPrimaryPage()
        viewController?.navigationController?.present(navc, animated: true, completion: nil)
    }
}
