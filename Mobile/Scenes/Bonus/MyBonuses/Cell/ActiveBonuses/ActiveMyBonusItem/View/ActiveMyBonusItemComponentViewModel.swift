//
//  ActiveMyBonusItemComponentViewModel.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 29.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol ActiveMyBonusItemComponentViewModel: ActiveMyBonusItemComponentViewModelInput,
                                                ActiveMyBonusItemComponentViewModelOutput {}

public struct ActiveMyBonusItemComponentViewModelParams {
	var startDate: String
	var endDate: String
	var name: String
}

public protocol ActiveMyBonusItemComponentViewModelInput {
    func didBind()
	func playNowButtonClicked()
	func hintButtonClicked()
}

public protocol ActiveMyBonusItemComponentViewModelOutput {
    var action: Observable<ActiveMyBonusItemComponentViewModelOutputAction> { get }
    var params: ActiveMyBonusItemComponentViewModelParams { get }
	var date: String { get }
	var name: String { get }
}

public enum ActiveMyBonusItemComponentViewModelOutputAction {
}

public class DefaultActiveMyBonusItemComponentViewModel {
    public var params: ActiveMyBonusItemComponentViewModelParams
    private let actionSubject = PublishSubject<ActiveMyBonusItemComponentViewModelOutputAction>()
	public var date: String { get { "\(params.startDate) - \(params.endDate)" } }
	public var name: String { get { params.name } }

    public init(params: ActiveMyBonusItemComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultActiveMyBonusItemComponentViewModel: ActiveMyBonusItemComponentViewModel {
    public var action: Observable<ActiveMyBonusItemComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() {
//        actionSubject.onNext()
    }

	public func playNowButtonClicked() {
		// TODO: open game in app
	}

	public func hintButtonClicked() {
		// TODO: open partial view controller with hint text
	}
}
