//
//  GameViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 2/8/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol GameViewModel: GameViewModelInput, GameViewModelOutput {
}

public struct GameViewModelParams {
}

public protocol GameViewModelInput: AnyObject {
    var params: GameViewModelParams { get set }
    func viewDidLoad()
    func bedginGameLoadingAnimation()
    func finishGameLoadingAnimation()
}

public protocol GameViewModelOutput {
    var action: Observable<GameViewModelOutputAction> { get }
    var route: Observable<GameViewModelRoute> { get }
}

public enum GameViewModelOutputAction {
    case bindToGameLoader(viewModel: GameLoaderComponentViewModel)
}

public enum GameViewModelRoute {
}

public class DefaultGameViewModel {
    public var params: GameViewModelParams
    private let actionSubject = PublishSubject<GameViewModelOutputAction>()
    private let routeSubject = PublishSubject<GameViewModelRoute>()
    
    @Inject(from: .componentViewModels) private var gameLoaderViewModel: GameLoaderComponentViewModel

    public init(params: GameViewModelParams) {
        self.params = params
    }
}

extension DefaultGameViewModel: GameViewModel {
    public var action: Observable<GameViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<GameViewModelRoute> { routeSubject.asObserver() }
    
    public func viewDidLoad() {
        actionSubject.onNext(.bindToGameLoader(viewModel: gameLoaderViewModel))
    }
    
    public func bedginGameLoadingAnimation() {
        gameLoaderViewModel.begindAnimation()
    }
    
    public func finishGameLoadingAnimation() {
        gameLoaderViewModel.finishAnimation()
    }
}
