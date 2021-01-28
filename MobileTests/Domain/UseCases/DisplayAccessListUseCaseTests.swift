//
//  DisplayAccessListUseCaseTests.swift
//  MobileTests
//
//  Created by Irakli Shelia on 1/26/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

@testable import Mobile
import XCTest
class DisplayAccessListUseCaseTests: XCTestCase {
    
    // MARK: Subject under test
    var sut: DefaultAccessListUseCaseUseCase!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupDisplayAccessListUseCase()
    }
    
    override func tearDown()
    {
      super.tearDown()
    }
    
    // MARK: Test setup

    func setupDisplayAccessListUseCase() {
        sut = DefaultAccessListUseCaseUseCase()
    }

    func testGenerateRequestParameters() {
        // Given
        let params = Seeds.AccessHistory.displayAccessListUseCaseParams
        
        // When
        let requestParams = sut.generateRequestParams(from: params)
        
        // Then
        let endDate = sut.dayDateFormatter.date(from: params.toDate)
        let correctEndDate = Calendar.current.date(byAdding: .day, value: 1, to: endDate!)!
        let correctEndDateString = sut.dayDateFormatter.string(from: correctEndDate)
        
        XCTAssertEqual(correctEndDateString, requestParams.toDate, "One day should be added to the end date")
    }
}
