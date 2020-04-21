//
//  RecentlyPlayedComponentViewModel.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/21/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol RecentlyPlayedComponentViewModel: RecentlyPlayedComponentViewModelInput, RecentlyPlayedComponentViewModelOutput {
}

public struct RecentlyPlayedComponentViewModelParams {
    public let id: String
    public let title: String
    public let buttonTitle: String
    public let playedGames: [PlayedGameLauncherCollectionViewCellDataProvider]
}

public protocol RecentlyPlayedComponentViewModelInput {
    func didBind()
    func didSelectViewAll()
    func didSelect(viewModel: PlayedGameLauncherComponentViewModel, indexPath: IndexPath)
}

public protocol RecentlyPlayedComponentViewModelOutput {
    var action: PublishSubject<RecentlyPlayedComponentViewModelOutputAction> { get }
    var params: RecentlyPlayedComponentViewModelParams { get }
}

public enum RecentlyPlayedComponentViewModelOutputAction {
    case set(title: String, buttonTitle: String)
    case didSelectViewAll(RecentlyPlayedComponentViewModel)
    case didSelectPlayedGame(PlayedGameLauncherComponentViewModel, IndexPath)
}

public enum RecentlyPlayedComponentViewModelRoute {
}

public class DefaultRecentlyPlayedComponentViewModel {
    public let action = PublishSubject<RecentlyPlayedComponentViewModelOutputAction>()
    public var params: RecentlyPlayedComponentViewModelParams

    public init(params: RecentlyPlayedComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultRecentlyPlayedComponentViewModel: RecentlyPlayedComponentViewModel {
    public func didBind() {
        print(#function)
        action.onNext(.set(title: params.title, buttonTitle: params.buttonTitle))
    }

    public func didSelectViewAll() {
        action.onNext(.didSelectViewAll(self))
    }

    public func didSelect(viewModel: PlayedGameLauncherComponentViewModel, indexPath: IndexPath) {
        action.onNext(.didSelectPlayedGame(viewModel, indexPath))
    }
}
