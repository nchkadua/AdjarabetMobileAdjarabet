//
//  RecentlyPlayedComponentViewModel.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/21/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift
import Rswift

public protocol RecentlyPlayedComponentViewModel: RecentlyPlayedComponentViewModelInput, RecentlyPlayedComponentViewModelOutput {
}

public struct RecentlyPlayedComponentViewModelParams {
    public var id: String
    public var title: Rswift.StringResource
    public var buttonTitle: Rswift.StringResource
    public var playedGames: [PlayedGameLauncherCollectionViewCellDataProvider]
    public var isVisible: Bool
}

public protocol RecentlyPlayedComponentViewModelInput {
    func didBind()
    func didSelectViewAll()
    func didSelect(viewModel: PlayedGameLauncherComponentViewModel, indexPath: IndexPath)
}

public protocol RecentlyPlayedComponentViewModelOutput {
    var action: Observable<RecentlyPlayedComponentViewModelOutputAction> { get }
    var params: RecentlyPlayedComponentViewModelParams { get }
}

public enum RecentlyPlayedComponentViewModelOutputAction {
    case setupUI
    case set(title: String, buttonTitle: String)
    case didSelectViewAll(RecentlyPlayedComponentViewModel)
    case didSelectPlayedGame(PlayedGameLauncherComponentViewModel, IndexPath)
}

public enum RecentlyPlayedComponentViewModelRoute {
}

public class DefaultRecentlyPlayedComponentViewModel: DefaultBaseViewModel {
    public let actionSubject = PublishSubject<RecentlyPlayedComponentViewModelOutputAction>()
    public var params: RecentlyPlayedComponentViewModelParams

    public init(params: RecentlyPlayedComponentViewModelParams) {
        self.params = params
    }

    public override func languageDidChange() {
        actionSubject.onNext(.setupUI)
        actionSubject.onNext(.set(title: params.title.localized(), buttonTitle: params.buttonTitle.localized()))
    }
}

extension DefaultRecentlyPlayedComponentViewModel: RecentlyPlayedComponentViewModel {
    public var action: Observable<RecentlyPlayedComponentViewModelOutputAction> { actionSubject.asObserver() }

    public func didBind() {
        disposeBag = DisposeBag()
        observeLanguageChange()
        actionSubject.onNext(.set(title: params.title.localized(), buttonTitle: params.buttonTitle.localized()))
    }

    public func didSelectViewAll() {
        actionSubject.onNext(.didSelectViewAll(self))
    }

    public func didSelect(viewModel: PlayedGameLauncherComponentViewModel, indexPath: IndexPath) {
        actionSubject.onNext(.didSelectPlayedGame(viewModel, indexPath))
    }
}
