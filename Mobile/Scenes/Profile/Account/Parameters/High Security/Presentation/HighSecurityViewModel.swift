//
//  HighSecurityViewModel.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 6/25/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

protocol HighSecurityViewModel: HighSecurityViewModelInput,
                                HighSecurityViewModelOutput { }

protocol HighSecurityViewModelInput: AnyObject {
    func viewDidLoad()
}

protocol HighSecurityViewModelOutput {
    var action: Observable<HighSecurityViewModelOutputAction> { get }
    var route: Observable<HighSecurityViewModelRoute> { get }
}

enum HighSecurityViewModelOutputAction {
}

enum HighSecurityViewModelRoute {
}

class DefaultHighSecurityViewModel {
    private let actionSubject = PublishSubject<HighSecurityViewModelOutputAction>()
    private let routeSubject = PublishSubject<HighSecurityViewModelRoute>()
}

extension DefaultHighSecurityViewModel: HighSecurityViewModel {
    var action: Observable<HighSecurityViewModelOutputAction> { actionSubject.asObserver() }
    var route: Observable<HighSecurityViewModelRoute> { routeSubject.asObserver() }

    func viewDidLoad() {
    }
}
