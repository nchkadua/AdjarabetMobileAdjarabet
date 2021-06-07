//
//  MailChangeViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 11/24/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol MailChangeViewModel: MailChangeViewModelInput, MailChangeViewModelOutput {
}

public protocol MailChangeViewModelInput {
    func viewDidLoad()
}

public protocol MailChangeViewModelOutput {
    var action: Observable<MailChangeViewModelOutputAction> { get }
    var route: Observable<MailChangeViewModelRoute> { get }
}

public enum MailChangeViewModelOutputAction {
}

public enum MailChangeViewModelRoute {
}

public class DefaultMailChangeViewModel {
    private let actionSubject = PublishSubject<MailChangeViewModelOutputAction>()
    private let routeSubject = PublishSubject<MailChangeViewModelRoute>()
}

extension DefaultMailChangeViewModel: MailChangeViewModel {
    public var action: Observable<MailChangeViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<MailChangeViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
    }
}
