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
	let name: String
	let startDate: String
	let endDate: String?
	let condition: String
	let gameId: Int?

	init(name: String = "", startDate: String = "", endDate: String? = nil, condition: String, gameId: Int? = nil) {
		self.name = name
		self.startDate = startDate
		self.endDate = endDate
		self.condition = condition
		self.gameId = gameId
	}
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
	var condition: String { get }
	var gameId: Int? { get }
}

public enum ActiveMyBonusItemComponentViewModelOutputAction {
}

public class DefaultActiveMyBonusItemComponentViewModel {
    public var params: ActiveMyBonusItemComponentViewModelParams
    private let actionSubject = PublishSubject<ActiveMyBonusItemComponentViewModelOutputAction>()
	public var date: String {
		get {
			if let endDate = params.endDate {
				return "\(params.startDate) - \(endDate)"
			} else {
				return params.startDate
			}
		}
	}
	public var name: String { get { params.name } }
	public var condition: String { get { params.condition } }
	public var gameId: Int? { get { params.gameId } }

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
