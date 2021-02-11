//
//  GameLoaderComponentViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 2/8/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol GameLoaderComponentViewModel: GameLoaderComponentViewModelInput, GameLoaderComponentViewModelOutput {
}

public protocol GameLoaderComponentViewModelInput {
    func didBind()
    func begindAnimation()
    func finishAnimation()
    func didBeginAnimation()
    func didFinishAnimation()
}

public protocol GameLoaderComponentViewModelOutput {
    var action: Observable<GameLoaderComponentViewModelOutputAction> { get }
}

public enum GameLoaderComponentViewModelOutputAction {
    case beginAnimation
    case finishAnimation
    case didBeginAnimation
    case didFinishAnimation
}

public class DefaultGameLoaderComponentViewModel {
    private let actionSubject = PublishSubject<GameLoaderComponentViewModelOutputAction>()
}

extension DefaultGameLoaderComponentViewModel: GameLoaderComponentViewModel {
    public var action: Observable<GameLoaderComponentViewModelOutputAction> { actionSubject.asObserver() }

    public func didBind() {
    }
    
    public func begindAnimation() {
        actionSubject.onNext(.beginAnimation)
    }
    
    public func finishAnimation() {
        actionSubject.onNext(.finishAnimation)
    }
    
    public func didBeginAnimation() {
        actionSubject.onNext(.didBeginAnimation)
    }
    
    public func didFinishAnimation() {
        actionSubject.onNext(.didFinishAnimation)
    }
}
