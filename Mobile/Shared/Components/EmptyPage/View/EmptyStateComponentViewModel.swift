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
	public var isEnabled: Bool
	public let numItems: Int		/// number of items in empty collection

    init(
        icon: UIImage = R.image.promotions.casino_icon()!,
        title: String = "",
        description: String = "",
        position: EmptyStatePosition = .centered,
		isEnabled: Bool = false,
		numItems: Int = 0
    ) {
        self.icon = icon
        self.title = title
        self.description = description
        self.position = position
		self.isEnabled = isEnabled
		self.numItems = numItems
    }
}

public protocol EmptyStateComponentViewModelInput {
    func didBind()
    func set(title: String)
	func enable()
	func disable()
	
	var numItems: Int { get }
	var isEnabled: Bool { get set }
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
			print("*** DefaultEmptyStateComponentViewModel isEnabled updated to -> \(isEnabled)")
		}
	}

    public var action: Observable<EmptyStateComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() { }
	
	public func enable() {
		print("*** DefaultEmptyStateComponentViewModel: enable")
		isEnabled = true
		actionSubject.onNext(.show)
	}
	
	public func disable() {
		print("*** DefaultEmptyStateComponentViewModel: disable")
		isEnabled = false
		actionSubject.onNext(.hide)
	}
	
	public func set(title: String) {
		actionSubject.onNext(.titleUpdate(title: title))
	}
	
}
