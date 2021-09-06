//
//  TitleDescriptionButtonComponentViewModel.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 06.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol TitleDescriptionButtonComponentViewModel: TitleDescriptionButtonComponentViewModelInput,
                                                TitleDescriptionButtonComponentViewModelOutput {}

public struct TitleDescriptionButtonComponentViewModelParams {
    var title: String
    var description: String
    var buttonName: String
}

public protocol TitleDescriptionButtonComponentViewModelInput {
    func didBind()
}

public protocol TitleDescriptionButtonComponentViewModelOutput {
    var action: Observable<TitleDescriptionButtonComponentViewModelOutputAction> { get }
    var params: TitleDescriptionButtonComponentViewModelParams { get }
}

public enum TitleDescriptionButtonComponentViewModelOutputAction {
    case setTitle(_ title: String)
    case setDescription(_ desctiption: String)
    case setButtonName(_ name: String)
}

public class DefaultTitleDescriptionButtonComponentViewModel {
    public var params: TitleDescriptionButtonComponentViewModelParams
    private let actionSubject = PublishSubject<TitleDescriptionButtonComponentViewModelOutputAction>()
    public init(params: TitleDescriptionButtonComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultTitleDescriptionButtonComponentViewModel: TitleDescriptionButtonComponentViewModel {
    
    public var action: Observable<TitleDescriptionButtonComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() {
        actionSubject.onNext(.setTitle(params.title))
        actionSubject.onNext(.setDescription(params.description))
        actionSubject.onNext(.setButtonName(params.buttonName))
    }
}
