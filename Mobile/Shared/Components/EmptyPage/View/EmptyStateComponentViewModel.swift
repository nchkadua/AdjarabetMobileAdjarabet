//
//  EmptyPageComponentViewModel.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 13.08.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol EmptyStateComponentViewModel: EmptyStateComponentViewModelInput,
                                                EmptyStateComponentViewModelOutput {}

public struct EmptyStateComponentViewModelParams {
    public let icon: UIImage
    public let title: String
    public let description: String
    public let position: EmptyStatePosition
	/// view will be displayed only when it is enabled and required
	public var isEnabled: Bool		/// is allowed from customer to display
	public var isRequired: Bool		/// should be displayed, seems like collections is empty
	public let numItems: Int		/// number of items in empty collection
	
    init(
        icon: UIImage = R.image.promotions.casino_icon()!,
        title: String = "",
        description: String = "",
        position: EmptyStatePosition = .centered,
		isEnabled: Bool = false,
		isRequired: Bool = true,
		numItems: Int = 0
    ) {
        self.icon = icon
        self.title = title
        self.description = description
        self.position = position
		self.isEnabled = isEnabled
		self.isRequired = isRequired
		self.numItems = numItems
    }
}

public protocol EmptyStateComponentViewModelInput {
    func didBind()
    func set(title: String)
	
	var numItems: Int { get }
	var isEnabled: Bool { get set }
	var isRequired: Bool { get set }
}

public protocol EmptyStateComponentViewModelOutput {
    var action: Observable<EmptyStateComponentViewModelOutputAction> { get }
    var params: EmptyStateComponentViewModelParams { get }
}

public enum EmptyStateComponentViewModelOutputAction {
	case hide
	case show
	case titleUpdate(title: String)
}

public class DefaultEmptyStateComponentViewModel {
    public var params: EmptyStateComponentViewModelParams
    private let actionSubject = PublishSubject<EmptyStateComponentViewModelOutputAction>()
    public init(params: EmptyStateComponentViewModelParams) {
        self.params = params
    }
}

public enum EmptyStatePosition {
    case centered
    case centeredWithBottomSpace(space: CGFloat)
}

extension DefaultEmptyStateComponentViewModel: EmptyStateComponentViewModel {
	
	public var numItems: Int {
		get {
			params.numItems
		}
	}
	
	public var isEnabled: Bool {
		get {
			params.isEnabled
		}
		set {
			params.isEnabled = newValue
			refreshHideness()
			print("*** DefaultEmptyStateComponentViewModel isEnabled updated to -> \(isEnabled)")
		}
	}
	
	public var isRequired: Bool {
		get {
			params.isRequired
		}
		set {
			params.isRequired = newValue
			refreshHideness()
		}
	}

	private func refreshHideness() {
		if isEnabled && isRequired {
			actionSubject.onNext(.show)
		} else {
			actionSubject.onNext(.hide)
		}
	}
	
    public var action: Observable<EmptyStateComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() { }
	
	public func set(title: String) {
		actionSubject.onNext(.titleUpdate(title: title))
	}
	
}
