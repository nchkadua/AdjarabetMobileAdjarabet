//
//  AddCardViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 12/3/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol AddCardViewModel: AddCardViewModelInput, AddCardViewModelOutput {
}

public struct AddCardViewModelParams {
    public init() {
    }
}

public protocol AddCardViewModelInput: AnyObject {
    var params: AddCardViewModelParams { get set }
    func viewDidLoad()
}

public protocol AddCardViewModelOutput {
    var action: Observable<AddCardViewModelOutputAction> { get }
    var route: Observable<AddCardViewModelRoute> { get }
}

public enum AddCardViewModelOutputAction {
    case bindToMinAmountComponentViewModel(_ viewModel: MinAmountComponentViewModel)
    case bindToAgreementComponentViewModel(_ viewModel: AgreementComponentViewModel)
}

public enum AddCardViewModelRoute {
}

public class DefaultAddCardViewModel {
    public var params: AddCardViewModelParams
    private let actionSubject = PublishSubject<AddCardViewModelOutputAction>()
    private let routeSubject = PublishSubject<AddCardViewModelRoute>()

    @Inject (from: .componentViewModels) private var minAmountComponentViewModel: MinAmountComponentViewModel
    @Inject (from: .componentViewModels) private var agreementComponentViewModel: AgreementComponentViewModel

    public init(params: AddCardViewModelParams) {
        self.params = params
    }
}

extension DefaultAddCardViewModel: AddCardViewModel {
    public var action: Observable<AddCardViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<AddCardViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        actionSubject.onNext(.bindToMinAmountComponentViewModel(minAmountComponentViewModel))
        actionSubject.onNext(.bindToAgreementComponentViewModel(agreementComponentViewModel))
    }
}
