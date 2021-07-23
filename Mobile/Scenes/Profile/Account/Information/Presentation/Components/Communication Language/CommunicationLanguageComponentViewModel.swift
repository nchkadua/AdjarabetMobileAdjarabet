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
    let language: CommunicationLanguageEntity
}

public protocol CommunicationLanguageComponentViewModelInput {
    func didBind()
    func doneTapped(selectedLanguage: CommunicationLanguageEntity)
}

public protocol CommunicationLanguageComponentViewModelOutput {
    var action: Observable<CommunicationLanguageComponentViewModelOutputAction> { get }
    var params: CommunicationLanguageComponentViewModelParams { get }
}

public enum CommunicationLanguageComponentViewModelOutputAction {
    case setLanguage(_ language: CommunicationLanguageEntity)
    case doneTapped(_ selectedLanguage: CommunicationLanguageEntity)
}

class DefaultCommunicationLanguageComponentViewModel {
    let params: CommunicationLanguageComponentViewModelParams
    private let actionSubject = PublishSubject<CommunicationLanguageComponentViewModelOutputAction>()
    init(params: CommunicationLanguageComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultCommunicationLanguageComponentViewModel: CommunicationLanguageComponentViewModel {
    var action: Observable<CommunicationLanguageComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    func didBind() {
        actionSubject.onNext(.setLanguage(params.language))
    }

    func doneTapped(selectedLanguage: CommunicationLanguageEntity) {
        actionSubject.onNext(.doneTapped(selectedLanguage))
    }
}
