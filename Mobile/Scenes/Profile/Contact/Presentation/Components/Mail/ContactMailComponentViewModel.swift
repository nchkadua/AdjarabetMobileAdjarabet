//
//  ContactMailComponentViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 26.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol ContactMailComponentViewModel: ContactMailComponentViewModelInput,
                                                ContactMailComponentViewModelOutput {}

public struct ContactMailComponentViewModelParams {
}

public protocol ContactMailComponentViewModelInput {
    func didBind()
}

public protocol ContactMailComponentViewModelOutput {
    var action: Observable<ContactMailComponentViewModelOutputAction> { get }
    var params: ContactMailComponentViewModelParams { get }
}

public enum ContactMailComponentViewModelOutputAction {
}

public class DefaultContactMailComponentViewModel {
    public var params: ContactMailComponentViewModelParams
    private let actionSubject = PublishSubject<ContactMailComponentViewModelOutputAction>()
    public init(params: ContactMailComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultContactMailComponentViewModel: ContactMailComponentViewModel {
    public var action: Observable<ContactMailComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() {
//        actionSubject.onNext()
    }
}
