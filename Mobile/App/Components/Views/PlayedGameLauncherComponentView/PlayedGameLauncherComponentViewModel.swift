//
//  PlayedGameLauncherComponentViewModel.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/21/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol PlayedGameLauncherComponentViewModel: PlayedGameLauncherComponentViewModelInput, PlayedGameLauncherComponentViewModelOutput {
}

public struct PlayedGameLauncherComponentViewModelParams {
    public let id: String
    public let coverUrl: URL
    public let name: String
    public let lastWon: String
}

public protocol PlayedGameLauncherComponentViewModelInput {
    func didBind()
}

public protocol PlayedGameLauncherComponentViewModelOutput {
    var action: PublishSubject<PlayedGameLauncherComponentViewModelOutputAction> { get }
    var params: PlayedGameLauncherComponentViewModelParams { get }
}

public enum PlayedGameLauncherComponentViewModelOutputAction {
    case set(coverUrl: URL, name: String, lastWon: String)
    case didSelect(PlayedGameLauncherComponentViewModel, indexPath: IndexPath)
}

public enum PlayedGameLauncherComponentViewModelRoute {
}

public class DefaultPlayedGameLauncherComponentViewModel {
    public let action = PublishSubject<PlayedGameLauncherComponentViewModelOutputAction>()
    public var params: PlayedGameLauncherComponentViewModelParams

    public init(params: PlayedGameLauncherComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultPlayedGameLauncherComponentViewModel: PlayedGameLauncherComponentViewModel {
    public func didBind() {
        print(#function)
        action.onNext(.set(coverUrl: params.coverUrl, name: params.name, lastWon: params.lastWon))
    }
}
