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
    public let lastWon: String?
}

public protocol PlayedGameLauncherComponentViewModelInput {
    func didBind()
    func didSelect(at indexPath: IndexPath)
}

public protocol PlayedGameLauncherComponentViewModelOutput {
    var action: Observable<PlayedGameLauncherComponentViewModelOutputAction> { get }
    var params: PlayedGameLauncherComponentViewModelParams { get }
}

public enum PlayedGameLauncherComponentViewModelOutputAction {
    case set(coverUrl: URL, name: String, lastWon: String?)
    case didSelect(PlayedGameLauncherComponentViewModel, indexPath: IndexPath)
}

public enum PlayedGameLauncherComponentViewModelRoute {
}

public class DefaultPlayedGameLauncherComponentViewModel {
    public let actionSubject = PublishSubject<PlayedGameLauncherComponentViewModelOutputAction>()
    public var params: PlayedGameLauncherComponentViewModelParams

    public init(params: PlayedGameLauncherComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultPlayedGameLauncherComponentViewModel: PlayedGameLauncherComponentViewModel {
    public var action: Observable<PlayedGameLauncherComponentViewModelOutputAction> { actionSubject.asObserver() }

    public func didBind() {
        actionSubject.onNext(.set(coverUrl: params.coverUrl, name: params.name, lastWon: params.lastWon))
    }

    public func didSelect(at indexPath: IndexPath) {
        actionSubject.onNext(.didSelect(self, indexPath: indexPath))
    }
}
