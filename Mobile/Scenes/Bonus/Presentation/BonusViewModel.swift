//
//  BonusViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 4/26/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

protocol BonusViewModel: BaseViewModel, BonusViewModelInput, BonusViewModelOutput {
}

struct BonusViewModelParams {
}

protocol BonusViewModelInput: AnyObject {
    var params: BonusViewModelParams { get set }
    func viewDidLoad()
}

protocol BonusViewModelOutput {
    var action: Observable<BonusViewModelOutputAction> { get }
    var route: Observable<BonusViewModelRoute> { get }
}

enum BonusViewModelOutputAction {
}

enum BonusViewModelRoute {
}

class DefaultBonusViewModel: DefaultBaseViewModel {
    var params: BonusViewModelParams
    private let actionSubject = PublishSubject<BonusViewModelOutputAction>()
    private let routeSubject = PublishSubject<BonusViewModelRoute>()

    init(params: BonusViewModelParams) {
        self.params = params
    }
}

extension DefaultBonusViewModel: BonusViewModel {
    var action: Observable<BonusViewModelOutputAction> { actionSubject.asObserver() }
    var route: Observable<BonusViewModelRoute> { routeSubject.asObserver() }

    func viewDidLoad() {
    }
}
