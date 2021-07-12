//
//  CommunicationLanguageComponentViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 12.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol CommunicationLanguageComponentViewModel: CommunicationLanguageComponentViewModelInput,
                                                CommunicationLanguageComponentViewModelOutput {}

public struct CommunicationLanguageComponentViewModelParams {
}

public protocol CommunicationLanguageComponentViewModelInput {
    func didBind()
}

public protocol CommunicationLanguageComponentViewModelOutput {
    var action: Observable<CommunicationLanguageComponentViewModelOutputAction> { get }
    var params: CommunicationLanguageComponentViewModelParams { get }
}

public enum CommunicationLanguageComponentViewModelOutputAction {
}

public class DefaultCommunicationLanguageComponentViewModel {
    public var params: CommunicationLanguageComponentViewModelParams
    private let actionSubject = PublishSubject<CommunicationLanguageComponentViewModelOutputAction>()
    public init(params: CommunicationLanguageComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultCommunicationLanguageComponentViewModel: CommunicationLanguageComponentViewModel {
    public var action: Observable<CommunicationLanguageComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() {
//        actionSubject.onNext()
    }
}
