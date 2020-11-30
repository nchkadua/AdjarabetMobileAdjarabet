//
//  CashFlowViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/29/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol CashFlowViewModel: CashFlowViewModelInput, CashFlowViewModelOutput {
}

public struct CashFlowViewModelParams {
    var initialPageIndex: Int

    public init (initialPageIndex: Int) {
        self.initialPageIndex = initialPageIndex
    }
}

public protocol CashFlowViewModelInput: AnyObject {
    var params: CashFlowViewModelParams { get set }
    func viewDidLoad()
    func viewWillAppear()
    func viewDidDissappear()
    func shouldSelectTabButton(at index: Int, animate: Bool)
}

public protocol CashFlowViewModelOutput {
    var action: Observable<CashFlowViewModelOutputAction> { get }
    var route: Observable<CashFlowViewModelRoute> { get }
}

public enum CashFlowViewModelOutputAction {
    case shouldSelectTabButton(atIndex: Int)
    case bindToTabViewModel(viewModel: CashFlowTabComponentViewModel)
}

public enum CashFlowViewModelRoute {
}

public class DefaultCashFlowViewModel {
    public var params: CashFlowViewModelParams
    private let actionSubject = PublishSubject<CashFlowViewModelOutputAction>()
    private let routeSubject = PublishSubject<CashFlowViewModelRoute>()

    @Inject(from: .componentViewModels) private var tabViewModel: CashFlowTabComponentViewModel
    private var viewHasDissappeared = true

    public init (params: CashFlowViewModelParams = CashFlowViewModelParams(initialPageIndex: 0)) {
        self.params = params
    }
}

extension DefaultCashFlowViewModel: CashFlowViewModel {
    public var action: Observable<CashFlowViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<CashFlowViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        actionSubject.onNext(.bindToTabViewModel(viewModel: tabViewModel))
    }

    public func viewWillAppear() {
        if viewHasDissappeared {
            actionSubject.onNext(.shouldSelectTabButton(atIndex: params.initialPageIndex))
        }
        viewHasDissappeared = false
    }

    public func viewDidDissappear() {
        viewHasDissappeared = true
    }

    public func shouldSelectTabButton(at index: Int, animate: Bool) {
        tabViewModel.selectButton(at: index, animate: animate)
    }
}
