//
//  EndedMyBonusesHeaderComponentViewModel.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 30.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol EndedMyBonusesHeaderComponentViewModel: EndedMyBonusesHeaderComponentViewModelInput,
                                                EndedMyBonusesHeaderComponentViewModelOutput {}

public struct EndedMyBonusesHeaderComponentViewModelParams {
	var title: String

	init(title: String = R.string.localization.ended_bonuses.localized()) {
		self.title = title
	}
}

public protocol EndedMyBonusesHeaderComponentViewModelInput {
    func didBind()
}

public protocol EndedMyBonusesHeaderComponentViewModelOutput {
    var action: Observable<EndedMyBonusesHeaderComponentViewModelOutputAction> { get }
    var params: EndedMyBonusesHeaderComponentViewModelParams { get }
	var title: String { get }
}

public enum EndedMyBonusesHeaderComponentViewModelOutputAction {
}

public class DefaultEndedMyBonusesHeaderComponentViewModel {
    public var params: EndedMyBonusesHeaderComponentViewModelParams
    private let actionSubject = PublishSubject<EndedMyBonusesHeaderComponentViewModelOutputAction>()

	public var title: String { get { params.title.uppercased() } }

    public init(params: EndedMyBonusesHeaderComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultEndedMyBonusesHeaderComponentViewModel: EndedMyBonusesHeaderComponentViewModel {
    public var action: Observable<EndedMyBonusesHeaderComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() {
//        actionSubject.onNext()
    }

	public func didSelect(at indexPath: IndexPath) {
		// TODO
	}
}
