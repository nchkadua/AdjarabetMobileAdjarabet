//
//  EndedMyBonusItemComponentViewModel.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 29.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol EndedMyBonusItemComponentViewModel: EndedMyBonusItemComponentViewModelInput,
                                                EndedMyBonusItemComponentViewModelOutput {}

public struct EndedMyBonusItemComponentViewModelParams {
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

public protocol EndedMyBonusItemComponentViewModelInput {
    func didBind()
	func hintButtonTapped()
}

public protocol EndedMyBonusItemComponentViewModelOutput {
    var action: Observable<EndedMyBonusItemComponentViewModelOutputAction> { get }
    var params: EndedMyBonusItemComponentViewModelParams { get }
	var delegate: BonusItemDelegate? { get set }
	var startDate: String { get }
	var endDate: String { get }
	var name: String { get }
	var condition: String { get }
	var gameId: Int? { get }
}

public enum EndedMyBonusItemComponentViewModelOutputAction {
	case hideEndDate
	case hideHintButton
}

public class DefaultEndedMyBonusItemComponentViewModel {
    public var params: EndedMyBonusItemComponentViewModelParams
    private let actionSubject = PublishSubject<EndedMyBonusItemComponentViewModelOutputAction>()

	public var startDate: String { get { getDateLabel(params.startDate)?.uppercased() ?? "" } }
	public var endDate: String {
		get {
			if let endDateFormatted = getDateLabel(params.endDate) {
				return endDateFormatted.uppercased()
			} else {
				actionSubject.onNext(.hideEndDate)
				return ""
			}
		}
	}
	public var name: String { get { params.name.uppercased() } }
	public var condition: String {
		get {
			if let condition = params.condition {
				return condition
			} else {
				actionSubject.onNext(.hideHintButton)
				return ""
			}
		}
	}
	public var gameId: Int? { get { params.gameId } }
	public var delegate: BonusItemDelegate? {
		get { params.delegate }
		set { params.delegate = newValue }
	}

    public init(params: EndedMyBonusItemComponentViewModelParams) {
        self.params = params
    }

	private func getDateLabel(_ str: String?) -> String? {
		guard let str = str else { return "" }
		return str.changeDateFormat(from: "dd-MMM-yy HH:mm", to: "MMM dd")
	}
}

extension DefaultEndedMyBonusItemComponentViewModel: EndedMyBonusItemComponentViewModel {
    public var action: Observable<EndedMyBonusItemComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() { }

	public func hintButtonTapped() {
		delegate?.hintButtonClicked(description: condition, gameId: gameId)
	}
}
