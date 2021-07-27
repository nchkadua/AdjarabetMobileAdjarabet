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
    let title: String
    let mail: String
}

public protocol ContactMailComponentViewModelInput {
    func didBind()
    func didSelect(at indexPath: IndexPath)
}

public protocol ContactMailComponentViewModelOutput {
    var action: Observable<ContactMailComponentViewModelOutputAction> { get }
    var params: ContactMailComponentViewModelParams { get }
}

public enum ContactMailComponentViewModelOutputAction {
    case setup(title: String, mail: String)
    case didSelect(mail: String, indexPath: IndexPath)
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
        actionSubject.onNext(.setup(title: params.title, mail: params.mail))
    }

    public func didSelect(at indexPath: IndexPath) {
        actionSubject.onNext(.didSelect(mail: params.mail, indexPath: indexPath))
    }
}
