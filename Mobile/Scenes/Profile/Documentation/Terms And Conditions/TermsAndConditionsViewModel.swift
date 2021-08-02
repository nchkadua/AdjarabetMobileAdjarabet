//
//  TermsAndConditionsViewModel.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 30.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol TermsAndConditionsViewModel: TermsAndConditionsViewModelInput, TermsAndConditionsViewModelOutput {
}

public struct TermsAndConditionsViewModelParams {
}

public protocol TermsAndConditionsViewModelInput: AnyObject {
    var params: TermsAndConditionsViewModelParams { get set }
    func viewDidLoad()
}

public protocol TermsAndConditionsViewModelOutput {
    var action: Observable<TermsAndConditionsViewModelOutputAction> { get }
    var route: Observable<TermsAndConditionsViewModelRoute> { get }
}

public enum TermsAndConditionsViewModelOutputAction {
    case set(title: String)
    case didSelect(indexPath: IndexPath)
}

public enum TermsAndConditionsViewModelRoute {
    case initialize(AppListDataProvider)
}

public class DefaultTermsAndConditionsViewModel {
    public var params: TermsAndConditionsViewModelParams
    private let actionSubject = PublishSubject<TermsAndConditionsViewModelOutputAction>()
    private let routeSubject = PublishSubject<TermsAndConditionsViewModelRoute>()

    public init(params: TermsAndConditionsViewModelParams) {
        self.params = params
    }
}

extension DefaultTermsAndConditionsViewModel: TermsAndConditionsViewModel {
    public var action: Observable<TermsAndConditionsViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<TermsAndConditionsViewModelRoute> { routeSubject.asObserver() }
    
    public func viewDidLoad() {
    }
}
