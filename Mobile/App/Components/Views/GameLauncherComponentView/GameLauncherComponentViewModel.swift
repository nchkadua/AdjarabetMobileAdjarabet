//
//  GameLauncherComponentViewModel.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/19/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol GameLauncherComponentViewModel: GameLauncherComponentViewModelInput, GameLauncherComponentViewModelOutput {
}

public struct GameLauncherComponentViewModelParams {
    public var game: Game

    public var jackpotAmount: String? {
        guard let jackpot = game.jackpot, !jackpot.isEmpty else {return nil}

        return jackpot
    }

    public var category: String {
        "category \(game.category)"
    }
}

public protocol GameLauncherComponentViewModelInput {
    func didBind()
    func didSelect(at indexPath: IndexPath)
}

public protocol GameLauncherComponentViewModelOutput {
    var action: Observable<GameLauncherComponentViewModelOutputAction> { get }
    var params: GameLauncherComponentViewModelParams { get }
}

public enum GameLauncherComponentViewModelOutputAction {
    case set(coverUrl: URL, title: String, category: String, jackpotAmount: String?)
    case didSelect(GameLauncherComponentViewModel, indexPath: IndexPath)
}

public class DefaultGameLauncherComponentViewModel {
    public var params: GameLauncherComponentViewModelParams
    private let actionSubject = PublishSubject<GameLauncherComponentViewModelOutputAction>()

    public init(params: GameLauncherComponentViewModelParams) {
        self.params = params
    }

    public init(game: Game) {
        self.params = .init(game: game)
    }
}

extension DefaultGameLauncherComponentViewModel: GameLauncherComponentViewModel {
    public var action: Observable<GameLauncherComponentViewModelOutputAction> { actionSubject.asObserver() }

    public func didBind() {
        let game = params.game
        actionSubject.onNext(.set(coverUrl: game.coverUrl, title: game.name, category: params.category, jackpotAmount: params.jackpotAmount))
    }

    public func didSelect(at indexPath: IndexPath) {
        actionSubject.onNext(.didSelect(self, indexPath: indexPath))
    }
}
