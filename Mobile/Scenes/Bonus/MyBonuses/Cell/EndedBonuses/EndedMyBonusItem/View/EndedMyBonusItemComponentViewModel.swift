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
	var name: String
	var startDate: String
	var endDate: String

	public init(name: String = "", startDate: String = "", endDate: String = "") {
		self.name = name
		self.startDate = startDate
		self.endDate = endDate
	}
}

public protocol EndedMyBonusItemComponentViewModelInput {
    func didBind()
}

public protocol EndedMyBonusItemComponentViewModelOutput {
    var action: Observable<EndedMyBonusItemComponentViewModelOutputAction> { get }
    var params: EndedMyBonusItemComponentViewModelParams { get }
	var startDate: String { get }
	var endDate: String { get }
	var name: String { get }
}

public enum EndedMyBonusItemComponentViewModelOutputAction {
}

public class DefaultEndedMyBonusItemComponentViewModel {
    public var params: EndedMyBonusItemComponentViewModelParams
    private let actionSubject = PublishSubject<EndedMyBonusItemComponentViewModelOutputAction>()

	public var startDate: String { get { params.startDate.uppercased() } }
	public var endDate: String { get { params.endDate.uppercased() } }
	public var name: String { get { params.name.uppercased() } }

    public init(params: EndedMyBonusItemComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultEndedMyBonusItemComponentViewModel: EndedMyBonusItemComponentViewModel {
    public var action: Observable<EndedMyBonusItemComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() {
//        actionSubject.onNext()
    }
}
