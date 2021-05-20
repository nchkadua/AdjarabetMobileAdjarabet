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
    func count() -> Int
    func image(at index: Int) -> UIImage
    func pageCount() -> Int
    func index(of cell: Int) -> Int
    func rowToScroll(currentPage: Int, currentCell: Int) -> Int
    func nextPage(currentPage: Int) -> Int
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
    case reinitPager
    // for other listeners
    case tapped(atIndex: Int)
}

// MARK: - Default Implementation

class DefaultABSliderViewModel: ABSliderViewModel {
    private var slides: ABSliderViewModelSlides
    private let actionSubject = PublishSubject<ABSliderViewModelAction>()

    static var `default`: ABSliderViewModel { DefaultABSliderViewModel() }

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

    func count() -> Int { 64 } // 64 is big enought
    func image(at index: Int) -> UIImage { slides[index % slides.count].image }
    func pageCount() -> Int { slides.count }
    func index(of cell: Int) -> Int { cell % slides.count  }

    func rowToScroll(currentPage: Int, currentCell: Int) -> Int {
        if currentCell == count() - 1 { // edge case
            actionSubject.onNext(.reinitPager)
            return 0
        }
        let pageCount = self.pageCount()
        let remainder = currentCell % pageCount
        if remainder == pageCount - 1, currentPage == 0 {
            return currentCell - remainder + pageCount
        }
        return currentCell - remainder + currentPage
    }

    func nextPage(currentPage: Int) -> Int {
        (currentPage + 1) % pageCount()
    }
}
