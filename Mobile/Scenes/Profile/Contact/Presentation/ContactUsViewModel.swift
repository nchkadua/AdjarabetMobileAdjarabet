//
//  ContactUsViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 26.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol ContactUsViewModel: ContactUsViewModelInput, ContactUsViewModelOutput {
}

public struct ContactUsViewModelParams {
    let showDismiss: Bool
}

public protocol ContactUsViewModelInput: AnyObject {
    var params: ContactUsViewModelParams { get set }
    func viewDidLoad()
}

public protocol ContactUsViewModelOutput {
    var action: Observable<ContactUsViewModelOutputAction> { get }
    var route: Observable<ContactUsViewModelRoute> { get }
}

public enum ContactUsViewModelOutputAction {
    case initialize(AppListDataProvider)
}

public enum ContactUsViewModelRoute {
}

public class DefaultContactUsViewModel {
    public var params: ContactUsViewModelParams
    private let actionSubject = PublishSubject<ContactUsViewModelOutputAction>()
    private let routeSubject = PublishSubject<ContactUsViewModelRoute>()

    public init(params: ContactUsViewModelParams) {
        self.params = params
    }
}

extension DefaultContactUsViewModel: ContactUsViewModel {
    public var action: Observable<ContactUsViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<ContactUsViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        var dataProviders: AppCellDataProviders = []

        let contactPhoneViewModel = DefaultContactPhoneComponentViewModel(params: .init())
        dataProviders.append(contactPhoneViewModel)

        actionSubject.onNext(.initialize(dataProviders.makeList()))
    }
}
