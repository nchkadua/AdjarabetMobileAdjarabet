//
//  PromotionsViewController.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/14/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class PromotionsViewController: UIViewController {
    @Inject(from: .viewModels) private var viewModel: PromotionsViewModel
    private let disposeBag = DisposeBag()

    public override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    private func setup() {
        setBaseBackgorundColor()
        makeLeftBarButtonItemTitle(to: R.string.localization.promotions_page_title.localized())
    }

    private func bind(to viewModel: PromotionsViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didReceive(action: action)
        }).disposed(by: disposeBag)
    }

    private func didReceive(action: PromotionsViewModelOutputAction) {
        switch action {
        case .languageDidChange:
            setup()
        }
    }
}

extension PromotionsViewController: CommonBarButtonProviding { }
