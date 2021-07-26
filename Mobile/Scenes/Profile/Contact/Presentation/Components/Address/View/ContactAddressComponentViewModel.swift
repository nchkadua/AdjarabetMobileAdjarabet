//
//  ContactAddressComponentViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 26.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol ContactAddressComponentViewModel: ContactAddressComponentViewModelInput,
                                                ContactAddressComponentViewModelOutput {}

public struct ContactAddressComponentViewModelParams {
}

public protocol ContactAddressComponentViewModelInput {
    func didBind()
}

public protocol ContactAddressComponentViewModelOutput {
    var action: Observable<ContactAddressComponentViewModelOutputAction> { get }
    var params: ContactAddressComponentViewModelParams { get }
}

public enum ContactAddressComponentViewModelOutputAction {
}

public class DefaultContactAddressComponentViewModel {
    public var params: ContactAddressComponentViewModelParams
    private let actionSubject = PublishSubject<ContactAddressComponentViewModelOutputAction>()
    public init(params: ContactAddressComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultContactAddressComponentViewModel: ContactAddressComponentViewModel {
    public var action: Observable<ContactAddressComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() {
//        actionSubject.onNext()
    }
}
