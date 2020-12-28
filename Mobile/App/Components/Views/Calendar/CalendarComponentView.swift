//
//  CalendarComponentView.swift
//  Mobile
//
//  Created by Nika Chkadua on 11/26/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift
import FSCalendar

class CalendarComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: CalendarComponentViewModel!
    @Inject private var languageStorage: LanguageStorage

    private var firstDate: Date?
    private var lastDate: Date?
    private var datesRange: [Date]?

    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var calendar: FSCalendar!
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var arrowLeft: UIButton!
    @IBOutlet weak private var arrowRight: UIButton!

    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(.allCorners, radius: 13)
    }

    public override init(frame: CGRect) {
       super.init(frame: frame)
       nibSetup()
    }

    public required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
       nibSetup()
    }

    public func setAndBind(viewModel: CalendarComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    public func bind() {
        disposeBag = DisposeBag()
        viewModel.action.subscribe(onNext: { [weak self] action in
            guard let self = self else { return }
            switch action {
            case .setupCalendar: self.setDate(self.calendar.currentPage)
            case .selectRange(let fromDate, let toDate):
                self.selectRange(fromDate: fromDate, toDate: toDate)
            default:
                break
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    @objc private func nextMonth() {
        calendar.setCurrentPage(monthByAdding(1) ?? Date(), animated: true)
        setDate(calendar.currentPage)
    }

    @objc private func previousMonth() {
        calendar.setCurrentPage(monthByAdding(-1) ?? Date(), animated: true)
        setDate(calendar.currentPage)
    }

    private func monthByAdding(_ month: Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.month = month
        let month: Date? = Calendar.current.date(byAdding: dateComponents, to: calendar.currentPage) ?? Date()

        return month
    }

    private func setDate(_ date: Date) {
        dateLabel.setTextAndImage(ABDateFormatter.calendarDateFormatter(with: languageStorage.currentLanguage.localizableIdentifier).string(from: date), R.image.transactionsHistory.arrowRight() ?? UIImage(), alignment: .right, with: true)
    }
}

extension CalendarComponentView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue
        }
    }

    func setupUI() {
        view.setBackgorundColor(to: .tertiaryBg())
        setupCalendar()

        dateLabel.setFont(to: .title3(fontCase: .lower))
        dateLabel.setTextColor(to: .primaryText())

        arrowLeft.addTarget(self, action: #selector(previousMonth), for: .touchUpInside)
        arrowRight.addTarget(self, action: #selector(nextMonth), for: .touchUpInside)
    }

    func setupCalendar() {
        calendar.dataSource = self
        calendar.delegate = self

        calendar.swipeToChooseGesture.isEnabled = true
        calendar.allowsMultipleSelection = true
        calendar.locale = Locale(identifier: languageStorage.currentLanguage.localizableIdentifier)
        calendar.placeholderType = .none
        calendar.headerHeight = 0
        //Colors
        calendar.setBackgorundColor(to: .tertiaryBg())
        calendar.appearance.headerTitleColor = DesignSystem.Color.primaryText().value
        calendar.appearance.weekdayTextColor = DesignSystem.Color.tertiaryText().value
        calendar.appearance.titlePlaceholderColor = DesignSystem.Color.querternaryText().value
        calendar.appearance.titleDefaultColor = DesignSystem.Color.primaryText().value
        calendar.appearance.selectionColor = DesignSystem.Color.tertiaryText().value
        calendar.appearance.todaySelectionColor = DesignSystem.Color.tertiaryText().value
        calendar.appearance.todayColor = .clear
        calendar.appearance.titleTodayColor = DesignSystem.Color.primaryRed().value
        //Fonts
        calendar.appearance.headerTitleFont = DesignSystem.Typography.title3(fontCase: .lower).description.font
        calendar.appearance.weekdayFont = DesignSystem.Typography.footnote(fontCase: .lower).description.font
        calendar.appearance.titleFont = DesignSystem.Typography.headline(fontCase: .lower).description.font
    }

    public func selectRange(fromDate: Date, toDate: Date) {
        // Check if passed date is within 'logical' range
        guard fromDate >= Date.from(year: 1900, month: 01, day: 01)! else { return }
        self.calendar(calendar, didSelect: fromDate, at: .current)
        self.calendar(calendar, didSelect: toDate, at: .current)
    }
}

extension CalendarComponentView: FSCalendarDelegate, FSCalendarDataSource {
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        setDate(calendar.currentPage)
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // 'False Convert' to GMT+4. Better solution yet to come
        // Setting calendar.dateformmater.timeZone not working
        let date = date.advanced(by: 3600 * 4)
        if firstDate == nil {
            firstDate = date
            datesRange = [firstDate!]
            viewModel.didSelectRange(fromDate: datesRange!.first!, toDate: datesRange!.first!)
            return
        }

        if firstDate != nil && lastDate == nil {
            if date < firstDate! {
                calendar.deselect(firstDate!)
                firstDate = date
                datesRange = [firstDate!]
                return
            }

            let range = datesRange(from: firstDate!, to: date)
            lastDate = range.last

            for d in range {
                calendar.select(d)
            }
            datesRange = range
            viewModel.didSelectRange(fromDate: datesRange!.first!, toDate: datesRange!.last!)

            return
        }

        if firstDate != nil && lastDate != nil {
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }

            lastDate = nil
            firstDate = nil

            datesRange = []
        }
    }

    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        datesRange = []
        lastDate = nil
        firstDate = nil
        for d in calendar.selectedDates {
            calendar.deselect(d)
        }
        viewModel.didSelectRange(fromDate: Date.distantPast, toDate: Date.distantFuture)
    }

    func datesRange(from: Date, to: Date) -> [Date] {
        if from > to { return [Date]() }

        var tempDate = from
        var array = [tempDate]

        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }

        return array
    }
}
