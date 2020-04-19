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
}

public protocol GameLauncherComponentViewModelInput {
    func didBind()
}

public protocol GameLauncherComponentViewModelOutput {
    var action: PublishSubject<GameLauncherComponentViewModelOutputAction> { get }
    var params: GameLauncherComponentViewModelParams { get }
}

public enum GameLauncherComponentViewModelOutputAction {
    case set(coverUrl: URL, name: String, category: String)
    case didSelect(GameLauncherComponentViewModel, indexPath: IndexPath)
}

public class DefaultGameLauncherComponentViewModel {
    public var params: GameLauncherComponentViewModelParams
    public let action = PublishSubject<GameLauncherComponentViewModelOutputAction>()

    public init(params: GameLauncherComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultGameLauncherComponentViewModel: GameLauncherComponentViewModel {
    public func didBind() {
        // setup UI with title
        action.onNext(.set(coverUrl: params.coverUrl, name: params.name, category: params.category))
    }
}

extension DefaultGameLauncherComponentViewModel: AppCellDelegate {
    public func didSelect(at indexPath: IndexPath) {
        action.onNext(.didSelect(self, indexPath: indexPath))
    }
}
