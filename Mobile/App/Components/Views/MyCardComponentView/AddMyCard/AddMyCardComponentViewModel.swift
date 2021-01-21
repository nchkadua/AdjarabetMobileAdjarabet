//
//  AddMyCardComponentViewModel.swift
//  Mobile
//
//  Created by Irakli Shelia on 1/20/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol AddMyCardComponentViewModel: AddMyCardComponentViewModelInput,
                                                AddMyCardComponentViewModelOutput {}

public protocol AddMyCardComponentViewModelInput {
    func didBind()
    func didSelect(at indexPath: IndexPath)
}

public protocol AddMyCardComponentViewModelOutput {
    var action: Observable<AddMyCardComponentViewModelOutputAction> { get }
}

public enum AddMyCardComponentViewModelOutputAction {
    case didSelect(indexPath: IndexPath)
}

public class DefaultAddMyCardComponentViewModel {
    private let actionSubject = PublishSubject<AddMyCardComponentViewModelOutputAction>()
}

extension DefaultAddMyCardComponentViewModel: AddMyCardComponentViewModel {
    
    public func didSelect(at indexPath: IndexPath) {
        actionSubject.onNext(.didSelect(indexPath: indexPath))
    }
    
    public var action: Observable<AddMyCardComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() {}
}
