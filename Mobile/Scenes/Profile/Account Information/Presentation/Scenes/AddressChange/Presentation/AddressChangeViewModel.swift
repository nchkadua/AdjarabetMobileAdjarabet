//
//  AddressChangeViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 11/24/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol AddressChangeViewModel: AddressChangeViewModelInput, AddressChangeViewModelOutput {
}

public protocol AddressChangeViewModelInput {
    func viewDidLoad()
}

public protocol AddressChangeViewModelOutput {
    var action: Observable<AddressChangeViewModelOutputAction> { get }
    var route: Observable<AddressChangeViewModelRoute> { get }
}

public enum AddressChangeViewModelOutputAction {
}

public enum AddressChangeViewModelRoute {
}

public class DefaultAddressChangeViewModel {
    private let actionSubject = PublishSubject<AddressChangeViewModelOutputAction>()
    private let routeSubject = PublishSubject<AddressChangeViewModelRoute>()
}

extension DefaultAddressChangeViewModel: AddressChangeViewModel {
    public var action: Observable<AddressChangeViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<AddressChangeViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
    }
}
