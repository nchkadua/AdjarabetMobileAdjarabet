//
//  ResetOptionsViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 14.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol ResetOptionsViewModel: ResetOptionsViewModelInput, ResetOptionsViewModelOutput {
}

public struct ResetOptionsViewModelParams {
}

public protocol ResetOptionsViewModelInput: AnyObject {
    var params: ResetOptionsViewModelParams { get set }
    func viewDidLoad()
}

public protocol ResetOptionsViewModelOutput {
    var action: Observable<ResetOptionsViewModelOutputAction> { get }
    var route: Observable<ResetOptionsViewModelRoute> { get }
}

public enum ResetOptionsViewModelOutputAction {
}

public enum ResetOptionsViewModelRoute {
}

public class DefaultResetOptionsViewModel {
    public var params: ResetOptionsViewModelParams
    private let actionSubject = PublishSubject<ResetOptionsViewModelOutputAction>()
    private let routeSubject = PublishSubject<ResetOptionsViewModelRoute>()

    public init(params: ResetOptionsViewModelParams) {
        self.params = params
    }
}

extension DefaultResetOptionsViewModel: ResetOptionsViewModel {
    public var action: Observable<ResetOptionsViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<ResetOptionsViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
    }
}
