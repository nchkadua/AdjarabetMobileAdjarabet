//
//  AgreementComponentViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 12/3/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol AgreementComponentViewModel: AgreementComponentViewModelInput, AgreementComponentViewModelOutput {
}

public protocol AgreementComponentViewModelInput {
    func didBind()
    func agreementUpdated(agreed: Bool)
}

public protocol AgreementComponentViewModelOutput {
    var action: Observable<AgreementComponentViewModelOutputAction> { get }
}

public enum AgreementComponentViewModelOutputAction {
    case agreementUpdated(agreed: Bool)
}

public class DefaultAgreementComponentViewModel {
    private let actionSubject = PublishSubject<AgreementComponentViewModelOutputAction>()
}

extension DefaultAgreementComponentViewModel: AgreementComponentViewModel {
    public var action: Observable<AgreementComponentViewModelOutputAction> { actionSubject.asObserver() }

    public func didBind() {
    }

    public func agreementUpdated(agreed: Bool) {
        actionSubject.onNext(.agreementUpdated(agreed: agreed))
    }
}
