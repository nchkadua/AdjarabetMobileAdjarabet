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
    @IBOutlet public weak var scrollView: UIScrollView!

    public override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()

        scrollView.contentInset.bottom = 100

        func make(sw: UIStackView, text: String, style: DesignSystem.Button.Style, size: DesignSystem.Button.Size) {
            let button = ABButton(type: .system)
            sw.addArrangedSubview(button)
            button.set(size: size)
            button.set(style: style)
            button.setTitleWithoutAnimation(text, for: .normal)
        }

        func make(c: (UIStackView) -> Void) {
            let s = UIStackView()
            s.alignment = .center
            s.distribution = .fill
            s.axis = .vertical
            s.spacing = 10

            stackView.addArrangedSubview(s)

            c(s)
        }

        make { sw in
            DesignSystem.Button.Size.allCases.forEach {
                make(sw: sw, text: "DEFAULT", style: .primary(state: .normal), size: $0)
                make(sw: sw, text: "HOVERED", style: .primary(state: .hovered), size: $0)
                make(sw: sw, text: "ACTIVE", style: .primary(state: .acvite), size: $0)
                make(sw: sw, text: "FOCUSED", style: .primary(state: .focused), size: $0)
                make(sw: sw, text: "DISABLED", style: .primary(state: .disabled), size: $0)
                make(sw: sw, text: "LOADING", style: .primary(state: .loading), size: $0)
            }
        }

        make { sw in
            DesignSystem.Button.Size.allCases.forEach {
                make(sw: sw, text: "DEFAULT", style: .secondary(state: .normal), size: $0)
                make(sw: sw, text: "HOVERED", style: .secondary(state: .hovered), size: $0)
                make(sw: sw, text: "ACTIVE", style: .secondary(state: .acvite), size: $0)
                make(sw: sw, text: "FOCUSED", style: .secondary(state: .focused), size: $0)
                make(sw: sw, text: "DISABLED", style: .secondary(state: .disabled), size: $0)
                make(sw: sw, text: "LOADING", style: .secondary(state: .loading), size: $0)
            }
        }

        make { sw in
            DesignSystem.Button.Size.allCases.forEach {
                make(sw: sw, text: "DEFAULT", style: .tertiary(state: .normal), size: $0)
                make(sw: sw, text: "HOVERED", style: .tertiary(state: .hovered), size: $0)
                make(sw: sw, text: "ACTIVE", style: .tertiary(state: .acvite), size: $0)
                make(sw: sw, text: "FOCUSED", style: .tertiary(state: .focused), size: $0)
                make(sw: sw, text: "DISABLED", style: .tertiary(state: .disabled), size: $0)
                make(sw: sw, text: "LOADING", style: .tertiary(state: .loading), size: $0)
            }
        }

        make { sw in
            DesignSystem.Button.Size.allCases.forEach {
                make(sw: sw, text: "DEFAULT", style: .outline(state: .normal), size: $0)
                make(sw: sw, text: "HOVERED", style: .outline(state: .hovered), size: $0)
                make(sw: sw, text: "ACTIVE", style: .outline(state: .acvite), size: $0)
                make(sw: sw, text: "FOCUSED", style: .outline(state: .focused), size: $0)
                make(sw: sw, text: "DISABLED", style: .outline(state: .disabled), size: $0)
                make(sw: sw, text: "LOADING", style: .outline(state: .loading), size: $0)
            }
        }

        make { sw in
            DesignSystem.Button.Size.allCases.forEach {
                make(sw: sw, text: "DEFAULT", style: .ghost(state: .normal), size: $0)
                make(sw: sw, text: "HOVERED", style: .ghost(state: .hovered), size: $0)
                make(sw: sw, text: "ACTIVE", style: .ghost(state: .acvite), size: $0)
                make(sw: sw, text: "FOCUSED", style: .ghost(state: .focused), size: $0)
                make(sw: sw, text: "DISABLED", style: .ghost(state: .disabled), size: $0)
                make(sw: sw, text: "LOADING", style: .ghost(state: .loading), size: $0)
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
