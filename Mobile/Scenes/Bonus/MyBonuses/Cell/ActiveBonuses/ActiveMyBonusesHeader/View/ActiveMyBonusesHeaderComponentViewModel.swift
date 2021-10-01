//
//  ActiveMyBonusesHeaderComponentViewModel.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 30.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol ActiveMyBonusesHeaderComponentViewModel: ActiveMyBonusesHeaderComponentViewModelInput,
                                                ActiveMyBonusesHeaderComponentViewModelOutput {}

public struct ActiveMyBonusesHeaderComponentViewModelParams {
	var title: String
	var count: Int

	init(title: String = R.string.localization.active_bonuses.localized(), count: Int = 0) {
		self.title = title
		self.count = count
	}
}

public protocol ActiveMyBonusesHeaderComponentViewModelInput {
    func didBind()
}

public protocol ActiveMyBonusesHeaderComponentViewModelOutput {
    var action: Observable<ActiveMyBonusesHeaderComponentViewModelOutputAction> { get }
    var params: ActiveMyBonusesHeaderComponentViewModelParams { get }
	var title: String { get }
	var count: Int { get }
}

public enum ActiveMyBonusesHeaderComponentViewModelOutputAction {
}

public class DefaultActiveMyBonusesHeaderComponentViewModel {
    public var params: ActiveMyBonusesHeaderComponentViewModelParams
    private let actionSubject = PublishSubject<ActiveMyBonusesHeaderComponentViewModelOutputAction>()
	public var title: String { get { params.title.uppercased() } }
	public var count: Int { get { params.count } }

    public init(params: ActiveMyBonusesHeaderComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultActiveMyBonusesHeaderComponentViewModel: ActiveMyBonusesHeaderComponentViewModel {
    public var action: Observable<ActiveMyBonusesHeaderComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() {
//        actionSubject.onNext()
    }
}
