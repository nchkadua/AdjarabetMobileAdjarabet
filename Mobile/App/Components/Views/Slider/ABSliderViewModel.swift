//
//  ABSliderViewModel.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 5/18/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift
import UIKit

protocol ABSliderViewModel: ABSliderViewModelInput, ABSliderViewModelOutput { }

protocol ABSliderViewModelInput {
    // for view to call
    func onBind()
    // for others to mutate the state
    func set(slides: ABSliderViewModelSlides)
}

typealias ABSliderViewModelSlides = [ABSliderViewModelSlide]

struct ABSliderViewModelSlide {
    let image: UIImage
}

protocol ABSliderViewModelOutput {
    var action: Observable<ABSliderViewModelAction> { get }
}

enum ABSliderViewModelAction {
    // for view
    case reload
    // for other listeners
    case tapped(atIndex: Int)
}

// MARK: - Default Implementation

class DefaultABSliderViewModel: ABSliderViewModel {
    private var slides: ABSliderViewModelSlides
    private let actionSubject = PublishSubject<ABSliderViewModelAction>()

    init(slides: ABSliderViewModelSlides = []) {
        self.slides = slides
    }

    var action: Observable<ABSliderViewModelAction> { actionSubject.asObserver() }

    func onBind() {
        actionSubject.onNext(.reload)
    }

    func set(slides: ABSliderViewModelSlides) {
        self.slides = slides
        actionSubject.onNext(.reload)
    }
}
