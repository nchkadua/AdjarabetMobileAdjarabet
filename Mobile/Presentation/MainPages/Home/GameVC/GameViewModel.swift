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
    func viewDidDisappear()
    func beginGameLoadingAnimation()
    func finishGameLoadingAnimation()
}

protocol GameViewModelOutput {
    var action: Observable<GameViewModelOutputAction> { get }
    var route: Observable<GameViewModelRoute> { get }
}

enum GameViewModelOutputAction {
    case bindToGameLoader(viewModel: GameLoaderComponentViewModel)
    case load(url: URL)
    case show(error: String)
}

enum GameViewModelRoute { }

class DefaultGameViewModel {
    var params: GameViewModelParams
    private let actionSubject = PublishSubject<GameViewModelOutputAction>()
    private let routeSubject = PublishSubject<GameViewModelRoute>()
    private let interactor: GameLaunchInteractor = DefaultGameLaunchInteractor()
    @Inject(from: .componentViewModels)
    private var gameLoaderViewModel: GameLoaderComponentViewModel
    // state
    private var result: GameLaunchUrlResult?

    public init(params: GameViewModelParams) {
        self.params = params
    }
}

extension DefaultGameViewModel: GameViewModel {
    var action: Observable<GameViewModelOutputAction> { actionSubject.asObserver() }
    var route: Observable<GameViewModelRoute> { routeSubject.asObserver() }

    func viewDidLoad() {
        actionSubject.onNext(.bindToGameLoader(viewModel: gameLoaderViewModel))
        beginGameLoadingAnimation()
        let gameId = Int(params.game.id) ?? 0 == 0 ? "7400" : "7463" // FIXME
        interactor.launch(gameId: gameId) { [weak self] result in
            switch result {
            case .success(let result):
                self?.result = result
                self?.actionSubject.onNext(.load(url: result.url))
            case .failure(let error):
                self?.actionSubject.onNext(.show(error: error.localizedDescription))
            }
            self?.finishGameLoadingAnimation()
        }
    }

    func viewDidDisappear() {
        result?.gc.free()
    }

    func beginGameLoadingAnimation() {
        gameLoaderViewModel.begindAnimation()
    }

    func finishGameLoadingAnimation() {
        gameLoaderViewModel.finishAnimation()
    }
}
