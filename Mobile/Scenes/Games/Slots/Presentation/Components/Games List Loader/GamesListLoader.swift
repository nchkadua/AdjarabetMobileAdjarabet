//
//  GameListLoader.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 7/14/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public class GamesListLoader: UIView {
    private var isRecentlyPlayedEnabled: Bool = false

    private lazy var stackView: UIStackView = {
        let sw = UIStackView()
        sw.translatesAutoresizingMaskIntoConstraints = false
        sw.distribution = .fill
        sw.alignment = .fill
        sw.axis = .vertical
        return sw
    }()

    public init(isRecentlyPlayedEnabled: Bool) {
        super.init(frame: .zero)
        self.isRecentlyPlayedEnabled = isRecentlyPlayedEnabled
        sharedInitialize()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInitialize()
    }

    private func sharedInitialize() {
        addSubview(stackView)
        stackView.pin(to: self).bottom.isActive = false

        if isRecentlyPlayedEnabled {
            let v = RecentlyPlayedComponentView()
            v.translatesAutoresizingMaskIntoConstraints = false
            let params = RecentlyPlayedComponentViewModelParams(id: UUID().uuidString,
                                                                title: R.string.localization.recently_played,
                                                                buttonTitle: R.string.localization.view_all,
                                                                playedGames: [],
                                                                isVisible: true)
            v.viewModel = DefaultRecentlyPlayedComponentViewModel(params: params)
            v.bind()
            v.set(isLoading: true)
            stackView.addArrangedSubview(v)
            v.heightAnchor.constraint(equalToConstant: 208).isActive = true
        }

        (1...20).forEach { _ in
            let v = GameLauncherComponentView()
            v.translatesAutoresizingMaskIntoConstraints = false
            v.set(isLoading: true)
            stackView.addArrangedSubview(v)
        }
    }
}
