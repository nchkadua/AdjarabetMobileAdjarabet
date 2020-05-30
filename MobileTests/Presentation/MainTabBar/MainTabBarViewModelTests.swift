//
//  MainTabBarViewModelTests.swift
//  MobileTests
//
//  Created by Shota Ioramashvili on 4/16/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import XCTest
@testable import Mobile

class MainTabBarViewModelTests: XCTestCase {
    var viewModel: MainTabBarViewModel!
    
    override func setUpWithError() throws {
        viewModel = DefaultMainTabBarViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testMainTabBarViewModelViewDidLoad() {
        // given
        let initialExpectation = self.expectation(description: "Setup Tab Bar")
        let setupTabBarExpectation = self.expectation(description: "Initial")
        
        _ = viewModel.route.subscribe(onNext: { route in
            if case .initial = route { initialExpectation.fulfill() }
        })
        
        _ = viewModel.action.subscribe(onNext: { action in
            if case .setupTabBar = action { setupTabBarExpectation.fulfill() }
        })
        
        // when
        viewModel.viewDidLoad()
        
        // then
        waitForExpectations(timeout: 0.3, handler: nil)
    }
    
    func testMainTabBarViewModelViewDidLoadSelectSamePage() {
        // given
        let expectation = self.expectation(description: "Scroll to top")
        
        _ = viewModel.action.subscribe(onNext: { action in
            if case .scrollSelectedViewControllerToTop = action { expectation.fulfill() }
        })
        
        // when
        viewModel.shouldSelectPage(at: 0, currentPageIndex: 0)
        
        // then
        waitForExpectations(timeout: 0.3, handler: nil)
    }
    
    func testMainTabBarViewModelViewDidLoadSelectNewPage() {
        // given
        var selectedPage = 0
        
        _ = viewModel.action.subscribe(onNext: { action in
            if case .selectPage(let index) = action { selectedPage = index }
        })
        
        // when
        viewModel.shouldSelectPage(at: 1, currentPageIndex: 0)
        
        // then
        XCTAssertEqual(selectedPage, 1)
    }
}
