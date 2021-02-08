//
//  CardInfoViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 2/5/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol CardInfoViewModel: CardInfoViewModelInput, CardInfoViewModelOutput {
}

public struct CardInfoViewModelParams {
    public let amount: Double

    public init (amount: Double = 0.0) {
        self.amount = amount
    }
}

public protocol CardInfoViewModelInput: AnyObject {
    var params: CardInfoViewModelParams { get set }
    func viewDidLoad()
}

public protocol CardInfoViewModelOutput {
    var action: Observable<CardInfoViewModelOutputAction> { get }
    var route: Observable<CardInfoViewModelRoute> { get }
}

public enum CardInfoViewModelOutputAction {
}

public enum CardInfoViewModelRoute {
}

public class DefaultCardInfoViewModel {
    public var params: CardInfoViewModelParams
    private let actionSubject = PublishSubject<CardInfoViewModelOutputAction>()
    private let routeSubject = PublishSubject<CardInfoViewModelRoute>()

    public init(params: CardInfoViewModelParams) {
        self.params = params
    }
}

extension DefaultCardInfoViewModel: CardInfoViewModel {
    public var action: Observable<CardInfoViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<CardInfoViewModelRoute> { routeSubject.asObserver() }
    
    public func viewDidLoad() {
    }
}
