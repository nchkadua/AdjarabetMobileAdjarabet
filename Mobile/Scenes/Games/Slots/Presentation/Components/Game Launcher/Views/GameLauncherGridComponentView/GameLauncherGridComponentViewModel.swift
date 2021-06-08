//
//  GameLauncherGridComponentViewModel.swift
//  Mobile
//
//  Created by Irakli Shelia on 2/25/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol GameLauncherGridComponentViewModel: GameLauncherGridComponentViewModelInput,
                                                GameLauncherGridComponentViewModelOutput {}

public struct GameLauncherGridComponentViewModelParams {
    public var game: Game

    public var jackpotAmount: String? {
        guard let jackpot = game.jackpot, !jackpot.isEmpty else {return nil}

        return jackpot
    }
}

public protocol GameLauncherGridComponentViewModelInput {
    func didBind()
    func didSelect(at indexPath: IndexPath)
}

public protocol GameLauncherGridComponentViewModelOutput {
    var action: Observable<GameLauncherGridComponentViewModelOutputAction> { get }
    var params: GameLauncherGridComponentViewModelParams { get }
}

public enum GameLauncherGridComponentViewModelOutputAction {
    case set(coverUrl: URL, title: String, category: String, jackpotAmount: String?)
    case didSelect(viewModel: GameLauncherGridComponentViewModel, indexPath: IndexPath)
}

public class DefaultGameLauncherGridComponentViewModel {
    public var params: GameLauncherGridComponentViewModelParams
    private let actionSubject = PublishSubject<GameLauncherGridComponentViewModelOutputAction>()
    public init(params: GameLauncherGridComponentViewModelParams) {
        self.params = params
    }
    public init(game: Game) {
        self.params = .init(game: game)
    }
}

extension DefaultGameLauncherGridComponentViewModel: GameLauncherGridComponentViewModel {
    public var action: Observable<GameLauncherGridComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() {
        let game = params.game
        actionSubject.onNext(.set(coverUrl: game.coverUrl, title: game.name, category: game.category, jackpotAmount: params.jackpotAmount))
    }

    public func didSelect(at indexPath: IndexPath) {
        actionSubject.onNext(.didSelect(viewModel: self, indexPath: indexPath))
    }
}
