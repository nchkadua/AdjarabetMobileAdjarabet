//
//  BonusViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 4/26/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol BonusViewModel: BonusViewModelInput, BonusViewModelOutput {
}

public struct BonusViewModelParams {
}

public protocol BonusViewModelInput: AnyObject {
    var params: BonusViewModelParams { get set }
    func viewDidLoad()
}

public protocol BonusViewModelOutput {
    var action: Observable<BonusViewModelOutputAction> { get }
    var route: Observable<BonusViewModelRoute> { get }
}

public enum BonusViewModelOutputAction {
}

public enum BonusViewModelRoute {
}

public class DefaultBonusViewModel {
    public var params: BonusViewModelParams
    private let actionSubject = PublishSubject<BonusViewModelOutputAction>()
    private let routeSubject = PublishSubject<BonusViewModelRoute>()

    public init(params: BonusViewModelParams) {
        self.params = params
    }
}

extension DefaultBonusViewModel: BonusViewModel {
    public var action: Observable<BonusViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<BonusViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
    }
}
