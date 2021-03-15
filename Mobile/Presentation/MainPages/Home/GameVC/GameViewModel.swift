//
//  GameViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 2/8/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

protocol GameViewModel: GameViewModelInput, GameViewModelOutput { }

struct GameViewModelParams {
    let game: Game
}

protocol GameViewModelInput: AnyObject {
    var params: GameViewModelParams { get set }
    func viewDidLoad()
    func bedginGameLoadingAnimation()
    func finishGameLoadingAnimation()
}

protocol GameViewModelOutput {
    var action: Observable<GameViewModelOutputAction> { get }
    var route: Observable<GameViewModelRoute> { get }
}

enum GameViewModelOutputAction {
    case bindToGameLoader(viewModel: GameLoaderComponentViewModel)
}

enum GameViewModelRoute { }

class DefaultGameViewModel {
    var params: GameViewModelParams
    private let actionSubject = PublishSubject<GameViewModelOutputAction>()
    private let routeSubject = PublishSubject<GameViewModelRoute>()
    private let interactor: GameLaunchInteractor = DefaultGameLaunchInteractor()
    @Inject(from: .componentViewModels)
    private var gameLoaderViewModel: GameLoaderComponentViewModel

    public init(params: GameViewModelParams) {
        self.params = params
    }
}

extension DefaultGameViewModel: GameViewModel {
    var action: Observable<GameViewModelOutputAction> { actionSubject.asObserver() }
    var route: Observable<GameViewModelRoute> { routeSubject.asObserver() }

    func viewDidLoad() {
        actionSubject.onNext(.bindToGameLoader(viewModel: gameLoaderViewModel))
        print("GameViewModel.ViewDidLoad:", params.game.name)
    }

    func bedginGameLoadingAnimation() {
        gameLoaderViewModel.begindAnimation()
    }

    func finishGameLoadingAnimation() {
        gameLoaderViewModel.finishAnimation()
    }
}
