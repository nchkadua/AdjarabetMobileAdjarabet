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

    @IBOutlet public weak var stackView: UIStackView!

    public override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()

        func make(sw: UIStackView, text: String, style: DesignSystem.Button.Style) {
            let button = ABButton(type: .system)
            sw.addArrangedSubview(button)
            button.set(size: .large)
            button.set(style: style)
            button.setTitleWithoutAnimation(text, for: .normal)
        }

        func make(c: (UIStackView) -> Void) {
            let s = UIStackView()
            s.alignment = .center
            s.distribution = .fill
            s.axis = .vertical
            s.spacing = 5

            stackView.addArrangedSubview(s)

            c(s)
        }

        make { sw in
            DesignSystem.Button.State.allCases.forEach {
                make(sw: sw, text: "DEFAULT", style: .primary(state: $0))
            }
        }

        make { sw in
            DesignSystem.Button.State.allCases.forEach {
                make(sw: sw, text: "DEFAULT", style: .secondary(state: $0))
            }
        }

        make { sw in
            DesignSystem.Button.State.allCases.forEach {
                make(sw: sw, text: "DEFAULT", style: .tertiary(state: $0))
            }
        }

        make { sw in
            DesignSystem.Button.State.allCases.forEach {
                make(sw: sw, text: "DEFAULT", style: .outline(state: $0))
            }
        }

        make { sw in
            DesignSystem.Button.State.allCases.forEach {
                make(sw: sw, text: "DEFAULT", style: .ghost(state: $0))
            }
        }
    }

    private func setup() {
        setBaseBackgorundColor()
        setLeftBarButtonItemTitle(to: R.string.localization.promotions_page_title.localized())
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
