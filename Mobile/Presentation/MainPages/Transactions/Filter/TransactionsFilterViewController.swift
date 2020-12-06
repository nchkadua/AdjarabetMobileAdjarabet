//
//  TransactionsFilterViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 11/26/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class TransactionsFilterViewController: ABViewController {
    // MARK: - Outlets
    @IBOutlet private weak var calendarComponentView: CalendarComponentView!
    @IBOutlet private weak var filterTypeContainerView: UIView!
    @IBOutlet private weak var transactionsFilterButton: UIButton!
    @IBOutlet private weak var gamesFilterButton: UIButton!

    // MARK: - Properties
    @Inject(from: .viewModels) public var viewModel: TransactionsFilterViewModel
    public lazy var navigator = TransactionsFilterNavigator(viewController: self)
    private lazy var appTableViewController = ABTableViewController()

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
        viewModel.setupTransactionTypeList()
    }

    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupFilterLayers()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: TransactionsFilterViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: TransactionsFilterViewModelOutputAction) {
        switch action {
        case .initialize(let appListDataProvider):
            appTableViewController.dataProvider = appListDataProvider
        case .bindToCalendarComponentViewModel(let calendarComponentViewModel): bindToCalendar(calendarComponentViewModel)
        case .languageDidChange:
            // TODO
            print("Handle language Change")
        case .providerTypeSelected(let providerType):
            setupProviderButtons(forSelected: providerType)
        case .transactionTypeToggled:
            viewModel.setupTransactionTypeList()
        }
    }

    // MARK: CalendarComponentView
    private func bindToCalendar(_ calendarViewModel: CalendarComponentViewModel) {
        calendarComponentView.setAndBind(viewModel: calendarViewModel)
        bind(to: calendarViewModel)
    }

    private func bind(to viewModel: CalendarComponentViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: CalendarComponentViewModelOutputAction) {
        switch action {
        case .didSelectRange(let startDate, let endDate): filterWith(startDate, endDate)
        default:
            break
        }
    }

    // MARK: Action methods
    private func filterWith(_ startDate: Date, _ endDate: Date) {
        print("fromDate :\(startDate) --- toDate: \(endDate)")
        viewModel.filterSelected(fromDate: startDate, toDate: endDate)
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgorundColor(to: .secondaryBg())
        setupNavigationItems()
        setupTableView()
        setupFilterButtonFonts()
        setupFilterButtonColors()
    }

    private func setupProviderButtons(forSelected providerType: ProviderType) {
        if providerType == .transactions {
            setActiveColorsFor(on: transactionsFilterButton)
            setDisabledColors(on: gamesFilterButton)
        } else if providerType == .games {
            setActiveColorsFor(on: gamesFilterButton)
            setDisabledColors(on: transactionsFilterButton)
        }
    }

    private func setDisabledColors(on button: UIButton) {
        button.setTitleColor(DesignSystem.Color.secondaryText().value, for: .normal)
        button.setBackgorundColor(to: DesignSystem.Color.tertiaryBg())
    }

    private func setActiveColorsFor(on button: UIButton) {
        button.setTitleColor(DesignSystem.Color.primaryText().value, for: .normal)
        button.setBackgorundColor(to: DesignSystem.Color.systemGrey2())
    }

    private func setupFilterLayers() {
        filterTypeContainerView.roundCorners(.allCorners, radius: 8)
        gamesFilterButton.roundCorners(.allCorners, radius: 8)
        transactionsFilterButton.roundCorners(.allCorners, radius: 8)
    }

    private func setupFilterButtonFonts() {
        transactionsFilterButton.setFont(to: .footnote(fontCase: .lower))
        gamesFilterButton.setFont(to: .footnote(fontCase: .lower))
    }

    private func setupFilterButtonColors() {
        filterTypeContainerView.setBackgorundColor(to: DesignSystem.Color.tertiaryBg())
        setDisabledColors(on: gamesFilterButton)
        setDisabledColors(on: transactionsFilterButton)
    }

    private func setupTableView() {
        add(child: appTableViewController)
        appTableViewController.view.translatesAutoresizingMaskIntoConstraints = false
        appTableViewController.isTabBarManagementEnabled = true
        NSLayoutConstraint.activate([
            appTableViewController.view.leadingAnchor.constraint(equalTo: calendarComponentView.leadingAnchor),
            appTableViewController.view.trailingAnchor.constraint(equalTo: calendarComponentView.trailingAnchor),
            appTableViewController.view.topAnchor.constraint(equalTo: calendarComponentView.bottomAnchor),
            appTableViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupNavigationItems() {
        setTitle(title: R.string.localization.transactions_filter_title.localized())
        let saveButton = makeBarrButtonWith(title: "შენახვა")
        navigationItem.rightBarButtonItem = saveButton.barButtonItem
        saveButton.button.addTarget(self, action: #selector(saveClicked), for: .touchUpInside)
    }

    @objc func saveClicked() {
        viewModel.saveFilterClicked()
        navigationController?.dismiss(animated: true, completion: nil)
    }

    // MARK: Actions
    @IBAction func onGamesButtonClick(sender: Any) {
        viewModel.onClick(type: .games)
    }

    @IBAction func onTransactionsButtonClick(sender: Any) {
        viewModel.onClick(type: .transactions)
    }
}

extension TransactionsFilterViewController: CommonBarButtonProviding { }
