//
//  FooterComponentViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/7/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol FooterComponentViewModel: FooterComponentViewModelInput, FooterComponentViewModelOutput {
}

public struct FooterComponentViewModelParams {
    var backgroundColor: DesignSystem.Color
}

public protocol FooterComponentViewModelInput {
    func didBind()
    func didChangeLanguage()
}

public protocol FooterComponentViewModelOutput {
    var action: Observable<FooterComponentViewModelOutputAction> { get }
}

public enum FooterComponentViewModelOutputAction {
    case didChangeLanguage(FooterComponentViewModel)
    case setBackgroundColor(_ color: DesignSystem.Color)
}

public class DefaultFooterComponentViewModel: DefaultBaseViewModel {
    public let actionSubject = PublishSubject<FooterComponentViewModelOutputAction>()
    public var params: FooterComponentViewModelParams

    public init(params: FooterComponentViewModelParams) {
        self.params = params
    }

    public override func languageDidChange() {
    }
}

extension DefaultFooterComponentViewModel: FooterComponentViewModel {
    public var action: Observable<FooterComponentViewModelOutputAction> { actionSubject.asObserver() }

    public func didBind() {
        actionSubject.onNext(.setBackgroundColor(params.backgroundColor))
    }

    public func didChangeLanguage() {
        actionSubject.onNext(.didChangeLanguage(self))
    }
}
