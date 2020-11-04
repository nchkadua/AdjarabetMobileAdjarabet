//
//  CashFlowViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/29/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class CashFlowViewController: UIViewController {
    public var viewModel: CashFlowViewModel!
    public lazy var navigator = CashFlowNavigator(viewController: self)
    private let disposeBag = DisposeBag()

    @IBOutlet private weak var cashFlowTabView: CashFlowTabComponentView!
    @IBOutlet private weak var childrenVCFrameView: UIView!
    private lazy var appPageViewController: ABPageViewController = ABPageViewController(transitionStyle: .scroll)

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewDidDissappear()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: CashFlowViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: CashFlowViewModelOutputAction) {
        switch action {
        case .shouldSelectTabButton(let index):
            selectViewController(at: index)
            selectButton(at: index)
        case .bindToTabViewModel(let tabViewModel): bindToTab(tabViewModel)
        }
    }

    /// CashFlow Tab
    private func bindToTab(_ tabViewModel: CashFlowTabComponentViewModel) {
        cashFlowTabView.setAndBind(viewModel: tabViewModel)
        bind(to: tabViewModel)
    }

    private func bind(to viewModel: CashFlowTabComponentViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: CashFlowTabComponentViewModelOutputAction) {
        switch action {
        case .didSelectButton(let index, _): selectViewController(at: index)
        }
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgorundColor()
        setupPageViewController()
    }

    private func setupPageViewController() {
        add(child: appPageViewController)
        appPageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        appPageViewController.view.pin(to: childrenVCFrameView)

        appPageViewController.orderedViewControllers = [navigator.depositViewControllerFactory.make(), navigator.withdrawViewControllerFactory.make()]
    }

    // MARK: Action methods
    private func selectViewController(at index: Int) {
        appPageViewController.jumgToViewController(at: index)
    }

    private func selectButton(at index: Int) {
        viewModel.shouldSelectTabButton(at: index, animate: false)
    }
}
