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
    var fromDate: Date?
    var toDate: Date?
}

public protocol AccessHistoryCalendarViewModelInput: AnyObject {
    var params: AccessHistoryCalendarViewModelParams! { get set }
    func saveFilterClicked()
    func filterSelected(fromDate: Date, toDate: Date)
    func setupCalendar()
    func viewDidLoad()
}

public protocol AccessHistoryCalendarViewModelOutput {
    var action: Observable<AccessHistoryCalendarViewModelOutputAction> { get }
    var route: Observable<AccessHistoryCalendarViewModelRoute> { get }
}

public enum AccessHistoryCalendarViewModelOutputAction {
    case selectDateRange(fromDate: Date, toDate: Date)
}

public enum AccessHistoryCalendarViewModelRoute {
}

public class DefaultAccessHistoryCalendarViewModel {
    public var params: AccessHistoryCalendarViewModelParams!
    private let actionSubject = PublishSubject<AccessHistoryCalendarViewModelOutputAction>()
    private let routeSubject = PublishSubject<AccessHistoryCalendarViewModelRoute>()

    public init(params: AccessHistoryCalendarViewModelParams) {
        self.params = params
    }
}

extension DefaultAccessHistoryCalendarViewModel: AccessHistoryCalendarViewModel {
    public var action: Observable<AccessHistoryCalendarViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<AccessHistoryCalendarViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
    }

    public func saveFilterClicked() {
        params!.paramsOutputAction.onNext(.filterSelected(fromDate: params.fromDate, toDate: params.toDate))
    }

    public func filterSelected(fromDate: Date, toDate: Date) {
        params.fromDate = fromDate
        params.toDate = toDate
    }

    public func setupCalendar() {
        if params.fromDate != nil && params.toDate != nil {
            actionSubject.onNext(.selectDateRange(fromDate: params.fromDate!, toDate: params.toDate!))
        }
    }
}
