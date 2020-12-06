//
//  CalendarComponentViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 11/26/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol CalendarComponentViewModel: CalendarComponentViewModelInput, CalendarComponentViewModelOutput {
}

public protocol CalendarComponentViewModelInput {
    func didBind()
    func didSelectRange(fromDate: Date, toDate: Date)
}

public protocol CalendarComponentViewModelOutput {
    var action: Observable<CalendarComponentViewModelOutputAction> { get }
}

public enum CalendarComponentViewModelOutputAction {
    case setupCalendar
    case didSelectRange(fromDate: Date, toDate: Date)
}

public class DefaultCalendarComponentViewModel {
    private let actionSubject = PublishSubject<CalendarComponentViewModelOutputAction>()
}

extension DefaultCalendarComponentViewModel: CalendarComponentViewModel {
    public var action: Observable<CalendarComponentViewModelOutputAction> { actionSubject.asObserver() }

    public func didBind() {
        actionSubject.onNext(.setupCalendar)
    }

    public func didSelectRange(fromDate: Date, toDate: Date) {
        actionSubject.onNext(.didSelectRange(fromDate: fromDate, toDate: toDate))
    }
}
