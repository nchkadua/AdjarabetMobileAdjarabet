//
//  AccessHistoryCalendarViewController.swift
//  Mobile
//
//  Created by Irakli Shelia on 12/10/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class AccessHistoryCalendarViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet private weak var calendarComponentView: CalendarComponentView!
    // MARK: Properties
    @Inject(from: .viewModels) public var viewModel: AccessHistoryCalendarViewModel
    @Inject(from: .componentViewModels) private var calendarComponentViewModel: CalendarComponentViewModel
    public lazy var navigator = AccessHistoryCalendarNavigator(viewController: self)
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind(to: viewModel)
        bindToCalendar(to: calendarComponentViewModel)
        viewModel.viewDidLoad()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: AccessHistoryCalendarViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: AccessHistoryCalendarViewModelOutputAction) {
        switch action {
        case .selectDateRange(let fromDate, let toDate):
            self.calendarComponentView.selectRange(fromDate: fromDate, toDate: toDate)
        }
    }

    private func didRecive(route: AccessHistoryCalendarViewModelRoute) {
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgorundColor(to: .secondaryBg())
        setupNavigationItems()
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

    // MARK: CalendarComponentView

    private func bindToCalendar(to viewModel: CalendarComponentViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)
        calendarComponentView.setAndBind(viewModel: viewModel)
    }

    private func didRecive(action: CalendarComponentViewModelOutputAction) {
        switch action {
        case .didSelectRange(let startDate, let endDate):
            viewModel.filterSelected(fromDate: startDate, toDate: endDate)
        case .setupCalendar:
            viewModel.setupCalendar()
        default:
            break
        }
    }
}

extension AccessHistoryCalendarViewController: CommonBarButtonProviding { }
