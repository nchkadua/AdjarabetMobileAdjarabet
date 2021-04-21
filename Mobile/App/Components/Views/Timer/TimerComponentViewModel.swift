//
//  TimerComponentViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 11/26/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol TimerComponentViewModel: TimerComponentViewModelInput, TimerComponentViewModelOutput {
}

public protocol TimerComponentViewModelInput {
    func didBind()
    func start(from seconds: Int)
    func timerDidEnd()
    func stopTimer()
}

public protocol TimerComponentViewModelOutput {
    var action: Observable<TimerComponentViewModelOutputAction> { get }
}

public enum TimerComponentViewModelOutputAction {
    case startFrom(seconds: Int)
    case timerDidEnd
    case stopTimer
    case setAdditionalConstraint(constraint: CGFloat)
}

public class DefaultTimerComponentViewModel {
    private let actionSubject = PublishSubject<TimerComponentViewModelOutputAction>()
    @Inject private var languageStorage: LanguageStorage
}

extension DefaultTimerComponentViewModel: TimerComponentViewModel {
    public var action: Observable<TimerComponentViewModelOutputAction> { actionSubject.asObserver() }

    public func didBind() {
        switch languageStorage.currentLanguage {
        case .georgian: actionSubject.onNext(.setAdditionalConstraint(constraint: 32))
        case .english: actionSubject.onNext(.setAdditionalConstraint(constraint: -15))
        case .armenian: actionSubject.onNext(.setAdditionalConstraint(constraint: -15))
        }
    }

    public func start(from seconds: Int) {
        actionSubject.onNext(.startFrom(seconds: seconds))
    }

    public func timerDidEnd() {
        actionSubject.onNext(.timerDidEnd)
    }

    public func stopTimer() {
        actionSubject.onNext(.stopTimer)
    }
}
