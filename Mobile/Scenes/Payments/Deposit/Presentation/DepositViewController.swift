//
//  DepositViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/22/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public class DepositViewController: ABViewController {
    @Inject(from: .viewModels) var viewModel: DepositViewModel
    public lazy var navigator = DepositNavigator(viewController: self)

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var depositLabel: UILabel!
    @IBOutlet private weak var balanceTitleLabel: UILabel!
    @IBOutlet private weak var balanceLabel: UILabel!
    @IBOutlet private weak var loader: UIActivityIndicatorView!

    @IBOutlet private weak var paymentGridComponentView: PaymentMethodGridComponentView!
    @IBOutlet private weak var childrenVCFrameView: UIView!
    private var appPageViewController: ABPageViewController?

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        errorThrowing = viewModel
        viewModel.viewDidLoad()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewDidAppear()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: DepositViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: DepositViewModelOutputAction) {
        switch action {
        case .set(let totalBalance):
            set(totalBalance)
        case .bindToGridViewModel(let viewModel):
            bindToGrid(viewModel)
        case .didLoadPaymentMethods(let methods):
            setChildViewControllers(methods)
        case .loader(let isHidden):
            handleLoader(isHidden)
        }
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgroundColor()
        // setupPageViewController()
        setupLabels()
        setupImageView()
        loader.isHidden = true
    }

    private func setupPageViewController(with viewControllers: [UIViewController]) {
        appPageViewController = ABPageViewController(viewControllers: viewControllers)

        add(child: appPageViewController ?? ABPageViewController(viewControllers: []))
        appPageViewController?.view.translatesAutoresizingMaskIntoConstraints = false
        appPageViewController?.view.pin(to: childrenVCFrameView)
        appPageViewController?.setSwipeEnabled(false)
    }

    private func setupImageView() {
        iconImageView.image = R.image.deposit.icon()
    }

    private func setupLabels() {
        setupDepositLabel()
        setupBalanceTitleLabel()
        setupBalanceLabel()
    }
    
    private func setupDepositLabel() {
        depositLabel.setTextColor(to: .primaryText())
        depositLabel.setFont(to: .callout(fontCase: .upper, fontStyle: .semiBold))
        depositLabel.text = R.string.localization.deposit_deposit_title.localized().uppercased()
    }
    
    private func setupBalanceTitleLabel() {
        balanceTitleLabel.setTextColor(to: .secondaryText())
        balanceTitleLabel.setFont(to: .footnote(fontCase: .lower, fontStyle: .regular))
        balanceTitleLabel.text = R.string.localization.deposit_balance_title.localized()
    }
    
    private func setupBalanceLabel() {
        balanceLabel.setTextColor(to: .primaryText())
        balanceLabel.setFont(to: .title2(fontCase: .upper, fontStyle: .semiBold))
    }

    private func set(_ totalBalance: Double) {
        balanceLabel.text = totalBalance.formattedBalanceWithCurrencySign
    }

    /// Payment Grid
    private func bindToGrid(_ viewModel: PaymentMethodGridComponentViewModel) {
        paymentGridComponentView.setAndBind(viewModel: viewModel)
        bind(to: viewModel)
    }

    private func bind(to viewModel: PaymentMethodGridComponentViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: PaymentMethodGridComponentViewModelOutputAction) {
        switch action {
        case .didSelectPaymentMethod(let method, let indexPath): jumpToViewController(method, indexPath)
        default:
            break
        }
    }

    private func handleLoader(_ isHidden: Bool) {
        loader.isHidden = isHidden
        (isHidden ? loader.stopAnimating : loader.startAnimating)()

        appPageViewController?.view.isHidden = !isHidden
    }

    // MARK: Action methods
    private func setChildViewControllers(_ paymentMethodList: [PaymentMethodEntity]) {
        let visaVC = navigator.visaViewControllerFactory.make(params: .init(serviceType: .vip)).wrap(in: ABNavigationController.self)
        let emoneyVC = navigator.emoneyViewControllerFactory.make().wrap(in: ABNavigationController.self)
        let applePayVC = navigator.applePayViewControllerFactory.make().wrap(in: ABNavigationController.self)

        setupPageViewController(with: [visaVC, emoneyVC, applePayVC])
        jumpToViewController(by: PaymentMethodType(flowId: paymentMethodList[0].flowId) ?? .tbcRegular)
    }

    private func jumpToViewController(_ method: PaymentMethodComponentViewModel, _ indexPath: IndexPath) {
        jumpToViewController(by: PaymentMethodType(flowId: method.params.flowId) ?? .tbcRegular)
    }

    private func jumpToViewController(by paymentMethodType: PaymentMethodType) {
        guard let vc = navigator.viewController(by: paymentMethodType) else { return }
        appPageViewController?.jump(to: vc, direction: .forward, animated: false)
    }
}
