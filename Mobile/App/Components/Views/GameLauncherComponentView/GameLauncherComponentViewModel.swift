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
    public let id: String
    public let coverUrl: URL
    public let name: String
    public let category: String
    public let jackpotAmount: String?
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
}

extension DefaultGameLauncherComponentViewModel: GameLauncherComponentViewModel {
    public func didBind() {
        actionSubject.onNext(.set(coverUrl: params.coverUrl, title: params.name, category: params.category, jackpotAmount: params.jackpotAmount))
    }

    public var action: Observable<GameLauncherComponentViewModelOutputAction> { actionSubject.asObserver() }

    public func didSelect(at indexPath: IndexPath) {
        actionSubject.onNext(.didSelect(self, indexPath: indexPath))
    }
}
