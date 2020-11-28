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
//    private var viewModel: CalendarComponentViewModel!
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

//    public func setAndBind(viewModel: CalendarComponentViewModel) {
//        self.viewModel = viewModel
//        bind()
//    }

//    public func bind() {
//        viewModel?.action.subscribe(onNext: { [weak self] action in
//
//        }).disposed(by: disposeBag)
//
//        viewModel.didBind()
//    }
    
    @objc private func nextMonth() {
        var dateComponents = DateComponents()
        dateComponents.month = 1
        let nextMonth: Date? = Calendar.current.date(byAdding: dateComponents, to: calendar.currentPage) ?? Date()
        calendar.setCurrentPage(nextMonth!, animated: true)
        setDate(calendar.currentPage)
    }
    
    @objc private func previousMonth() {
        var dateComponents = DateComponents()
        dateComponents.month = -1
        let nextMonth: Date? = Calendar.current.date(byAdding: dateComponents, to: calendar.currentPage) ?? Date()
        calendar.setCurrentPage(nextMonth!, animated: true)
        setDate(calendar.currentPage)
    }
    
    private func setDate(_ date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: languageStorage.currentLanguage.localizableIdentifier)
        
        dateLabel.setTextAndImage(formatter.string(from: date), R.image.transactionsHistory.arrowRight() ?? UIImage(), alignment: .right)
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
        calendar.appearance.todaySelectionColor = .clear
        calendar.appearance.todayColor = .clear
        calendar.appearance.titleTodayColor = DesignSystem.Color.primaryRed().value
        //Fonts
        calendar.appearance.headerTitleFont = DesignSystem.Typography.title3(fontCase: .lower).description.font
        calendar.appearance.weekdayFont = DesignSystem.Typography.footnote(fontCase: .lower).description.font
        calendar.appearance.titleFont = DesignSystem.Typography.headline(fontCase: .lower).description.font
        
        //Move to setup after binding
        setDate(calendar.currentPage)
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        setDate(calendar.currentPage)
    }
}

// TODO: write better logic
extension CalendarComponentView: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        if firstDate == nil {
            firstDate = date
            datesRange = [firstDate!]
            return
        }

        // only first date is selected:
        if firstDate != nil && lastDate == nil {
            // handle the case of if the last date is less than the first date:
            if date <= firstDate! {
                calendar.deselect(firstDate!)
                firstDate = date
                datesRange = [firstDate!]

                print("datesRange contains 1: \(datesRange!)")

                return
            }

            let range = datesRange(from: firstDate!, to: date)

            lastDate = range.last

            for d in range {
                calendar.select(d)
            }

            datesRange = range

            print("datesRange contains 2: \(datesRange!)")

            return
        }

        // both are selected:
        if firstDate != nil && lastDate != nil {
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }

            lastDate = nil
            firstDate = nil

            datesRange = []

            print("datesRange contains 3: \(datesRange!)")
        }
    }

    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // both are selected:
        setDate(date)
        // NOTE: the is a REDUANDENT CODE:
        if firstDate != nil && lastDate != nil {
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }

            lastDate = nil
            firstDate = nil

            datesRange = []
            print("datesRange contains 4: \(datesRange!)")
        }
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
