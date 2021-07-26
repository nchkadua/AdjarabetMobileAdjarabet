//
//  ContactPhoneComponentViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 26.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol ContactPhoneComponentViewModel: ContactPhoneComponentViewModelInput,
                                                ContactPhoneComponentViewModelOutput {}

public struct ContactPhoneComponentViewModelParams {
}

public protocol ContactPhoneComponentViewModelInput {
    func didBind()
}

public protocol ContactPhoneComponentViewModelOutput {
    var action: Observable<ContactPhoneComponentViewModelOutputAction> { get }
    var params: ContactPhoneComponentViewModelParams { get }
}

public enum ContactPhoneComponentViewModelOutputAction {
}

public class DefaultContactPhoneComponentViewModel {
    public var params: ContactPhoneComponentViewModelParams
    private let actionSubject = PublishSubject<ContactPhoneComponentViewModelOutputAction>()
    public init(params: ContactPhoneComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultContactPhoneComponentViewModel: ContactPhoneComponentViewModel {
    public var action: Observable<ContactPhoneComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() {
//        actionSubject.onNext()
    }
}
