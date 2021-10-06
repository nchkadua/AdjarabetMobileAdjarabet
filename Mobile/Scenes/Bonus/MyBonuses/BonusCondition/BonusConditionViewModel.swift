//
//  BonusConditionViewModel.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 04.10.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol BonusConditionViewModel: BonusConditionViewModelInput, BonusConditionViewModelOutput {
}

public struct BonusConditionViewModelParams {
	var description: String
	var gameId: Int?

	public init(description: String = "", gameId: Int? = nil) {
		self.description = description
		self.gameId = gameId
	}
}

public protocol BonusConditionViewModelInput: AnyObject {
    var params: BonusConditionViewModelParams { get set }
	var description: String { get }
	var gameId: Int? { get }
    func viewDidLoad()
}

public protocol BonusConditionViewModelOutput {
    var action: Observable<BonusConditionViewModelOutputAction> { get }
    var route: Observable<BonusConditionViewModelRoute> { get }
}

public enum BonusConditionViewModelOutputAction {
	case updateTitleText(String)
	case updateDescriptionText(String)
	case updateCloseButtonTitleText(String)
	case updatePlayNowButtonTitleText(String)
}

public enum BonusConditionViewModelRoute {
}

public class DefaultBonusConditionViewModel {
    public var params: BonusConditionViewModelParams
    private let actionSubject = PublishSubject<BonusConditionViewModelOutputAction>()
    private let routeSubject = PublishSubject<BonusConditionViewModelRoute>()

	public var description: String { get { params.description } }
	public var gameId: Int? { get { params.gameId } }

    public init(params: BonusConditionViewModelParams) {
        self.params = params
    }
}

extension DefaultBonusConditionViewModel: BonusConditionViewModel {
    public var action: Observable<BonusConditionViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<BonusConditionViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() { }
}
