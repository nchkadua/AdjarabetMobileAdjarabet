//
//  AccessHistoryCalendarViewModel.swift
//  Mobile
//
//  Created by Irakli Shelia on 12/10/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol AccessHistoryCalendarViewModel: AccessHistoryCalendarViewModelInput, AccessHistoryCalendarViewModelOutput {
}

public struct AccessHistoryCalendarViewModelParams {
    public enum Action {
        case filterSelected(fromDate: Date?, toDate: Date?)
    }
    public let paramsOutputAction = PublishSubject<Action>()
}

public protocol AccessHistoryCalendarViewModelInput: AnyObject {
    var params: AccessHistoryCalendarViewModelParams? { get set }
    func saveFilterClicked()
    func filterSelected(fromDate: Date, toDate: Date)
    func viewDidLoad()
}

public protocol AccessHistoryCalendarViewModelOutput {
    var action: Observable<AccessHistoryCalendarViewModelOutputAction> { get }
    var route: Observable<AccessHistoryCalendarViewModelRoute> { get }
}

public enum AccessHistoryCalendarViewModelOutputAction {
    case filterSelected(fromDate: Date?, toDate: Date?)
    case bindToCalendarComponentViewModel(viewmodel: CalendarComponentViewModel)
}

public enum AccessHistoryCalendarViewModelRoute {
}

public class DefaultAccessHistoryCalendarViewModel {
    public var params: AccessHistoryCalendarViewModelParams?
    private let actionSubject = PublishSubject<AccessHistoryCalendarViewModelOutputAction>()
    private let routeSubject = PublishSubject<AccessHistoryCalendarViewModelRoute>()
    @Inject(from: .componentViewModels) private var calendarComponentViewModel: CalendarComponentViewModel
    private var fromDate: Date?
    private var toDate: Date?
    public init(params: AccessHistoryCalendarViewModelParams) {
        self.params = params
    }
}

extension DefaultAccessHistoryCalendarViewModel: AccessHistoryCalendarViewModel {
    public var action: Observable<AccessHistoryCalendarViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<AccessHistoryCalendarViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        actionSubject.onNext(.bindToCalendarComponentViewModel(viewmodel: calendarComponentViewModel))
    }

    public func saveFilterClicked() {
        params!.paramsOutputAction.onNext(.filterSelected(fromDate: self.fromDate, toDate: self.toDate))
    }

    public func filterSelected(fromDate: Date, toDate: Date) {
        self.fromDate = fromDate
        self.toDate = toDate
    }
}
