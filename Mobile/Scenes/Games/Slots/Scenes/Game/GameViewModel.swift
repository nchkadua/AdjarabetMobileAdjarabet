//
//  GameViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 2/8/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

protocol GameViewModel: BaseViewModel, GameViewModelInput, GameViewModelOutput { }

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
}

enum GameViewModelRoute { }

class DefaultGameViewModel: DefaultBaseViewModel {
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
        interactor.launch(gameId: params.game.id) { [weak self] result in
            switch result {
            case .success(let result):
                self?.result = result
                self?.actionSubject.onNext(.load(url: result.url))
            case .failure(let error):
                self?.show(error: .init(type: .from(error)))
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
