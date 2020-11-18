//
//  P2PTransferViewModel.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 11/18/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol P2PTransferViewModel: P2PTransferViewModelInput, P2PTransferViewModelOutput {
}

public protocol P2PTransferViewModelInput {
    func viewDidLoad()
}

public protocol P2PTransferViewModelOutput {
    var action: Observable<P2PTransferViewModelOutputAction> { get }
    var route: Observable<P2PTransferViewModelRoute> { get }
}

public enum P2PTransferViewModelOutputAction {
}

public enum P2PTransferViewModelRoute {
}

public class DefaultP2PTransferViewModel {
    private let actionSubject = PublishSubject<P2PTransferViewModelOutputAction>()
    private let routeSubject = PublishSubject<P2PTransferViewModelRoute>()
}

extension DefaultP2PTransferViewModel: P2PTransferViewModel {
    public var action: Observable<P2PTransferViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<P2PTransferViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
    }
}
