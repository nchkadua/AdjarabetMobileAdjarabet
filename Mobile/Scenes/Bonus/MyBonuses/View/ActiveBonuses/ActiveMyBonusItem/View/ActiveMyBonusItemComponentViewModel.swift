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
	let condition: String?
	let gameId: Int?
	var delegate: BonusItemDelegate?

	init(name: String = "", startDate: String = "", endDate: String? = nil, condition: String? = nil, gameId: Int? = nil, delegate: BonusItemDelegate? = nil) {
		self.name = name
		self.startDate = startDate
		self.endDate = endDate
		self.condition = condition
		self.gameId = gameId
		self.delegate = delegate
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
	var delegate: BonusItemDelegate? { get set }
	var playNowButtonTitle: String { get }
}

public enum ActiveMyBonusItemComponentViewModelOutputAction {
	case hideConditionButton
}

public class DefaultActiveMyBonusItemComponentViewModel {
    public var params: ActiveMyBonusItemComponentViewModelParams
    private let actionSubject = PublishSubject<ActiveMyBonusItemComponentViewModelOutputAction>()
	public var date: String {
		get {
			let startDateFormatted = getDateLabel(params.startDate)?.uppercased() ?? ""
			if let endDateFormatted = getDateLabel(params.endDate)?.uppercased() {
				return "\(startDateFormatted) - \(endDateFormatted)"
			} else {
				return "\(startDateFormatted)"
			}
		}
	}
	public var name: String { get { params.name } }
	public var condition: String {
		get {
			if let condition = params.condition {
				return condition
			} else {
				actionSubject.onNext(.hideConditionButton)
				return ""
			}
		}
	}
	public var gameId: Int? { get { params.gameId } }
	public var delegate: BonusItemDelegate? {
		get { params.delegate }
		set { params.delegate = newValue }
	}
	public var playNowButtonTitle: String {
		get {
			R.string.localization.my_bonuses_play_now.localized().uppercased()
		}
	}

	private func getDateLabel(_ str: String?) -> String? {
		guard let str = str else { return "" }
		return str.changeDateFormat(from: "dd-MMM-yy HH:mm", to: "MMM dd")
	}

    public init(params: ActiveMyBonusItemComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultActiveMyBonusItemComponentViewModel: ActiveMyBonusItemComponentViewModel {
    public var action: Observable<ActiveMyBonusItemComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() { }

	public func playNowButtonClicked() {
		delegate?.playButtonClicked(gameId: gameId)
		// TODO: open game in app
	}

	public func hintButtonClicked() {
		delegate?.hintButtonClicked(description: condition, gameId: gameId)
	}
}
