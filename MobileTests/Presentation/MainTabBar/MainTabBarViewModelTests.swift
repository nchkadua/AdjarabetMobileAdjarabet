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
        var isSetupTabBarCalled = false
        var isInitialCalled = false
        
        _ = viewModel.action.subscribe(onNext: { action in
            switch action {
            case .setupTabBar: isSetupTabBarCalled = true
            default: break
            }
        })
        
        _ = viewModel.route.subscribe(onNext: { route in
            switch route {
            case .initial: isInitialCalled = true
            }
        })
        
        // when
        viewModel.viewDidLoad()
        
        // then
        XCTAssertEqual(isSetupTabBarCalled, true)
        XCTAssertEqual(isInitialCalled, true)
    }
    
    func testMainTabBarViewModelViewDidLoadSelectSamePage() {
        // given
        var isScrollSelectedViewControllerToTop = false
        
        _ = viewModel.action.subscribe(onNext: { action in
            switch action {
            case .scrollSelectedViewControllerToTop: isScrollSelectedViewControllerToTop = true
            default: break
            }
        })
        
        // when
        viewModel.shouldSelectPage(at: 0, currentPageIndex: 0)
        
        // then
        XCTAssertEqual(isScrollSelectedViewControllerToTop, true)
    }
    
    func testMainTabBarViewModelViewDidLoadSelectNewPage() {
        // given
        var selectedPage = 0
        
        _ = viewModel.action.subscribe(onNext: { action in
            switch action {
            case .selectPage(let index): selectedPage = index
            default: break
            }
        })
        
        // when
        viewModel.shouldSelectPage(at: 1, currentPageIndex: 0)
        
        // then
        XCTAssertEqual(selectedPage, 1)
    }
}
