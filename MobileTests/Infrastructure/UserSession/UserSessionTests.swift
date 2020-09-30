//
//  UserSessionTests.swift
//  MobileTests
//
//  Created by Shota Ioramashvili on 5/4/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import XCTest
@testable import Mobile

class UserSessionTests: XCTestCase {
    private var userSession: UserSessionServices!
    
    override func setUp() {
        super.setUp()
        
        userSession = UserSession.current
        userSession.remove()
    }
    
    override func tearDown() {
        super.tearDown()

        userSession.remove()
    }
    
    public func testRemove() {
        // when
        userSession.remove()
        
        // than
        XCTAssertEqual(userSession.isLoggedIn, false)
        XCTAssertEqual(userSession.sessionId, nil)
        XCTAssertEqual(userSession.userId, nil)
        XCTAssertEqual(userSession.username, nil)
        XCTAssertEqual(userSession.currencyId, nil)
    }
    
    public func testLogin() {
        // when
        userSession.login()
        
        // than
        XCTAssertEqual(userSession.isLoggedIn, true)
    }
    
    public func testLogout() {
        // when
        userSession.logout()
        
        // than
        XCTAssertEqual(userSession.isLoggedIn, false)
    }
    
    public func testSetEdditionalFields() {
        // given
        let userId      = Int.random(in: 0...1000)
        let username    = "\(Int.random(in: 0...1000))"
        let sessionId   = "\(Int.random(in: 0...1000))"
        let currencyId  = Int.random(in: 0...1000)
        let password    = "\(Int.random(in: 0...1000))"
        
        // when
        userSession.set(userId: userId, username: username, sessionId: sessionId, currencyId: currencyId, password: password)
        
        // than
        XCTAssertEqual(userSession.sessionId, sessionId)
        XCTAssertEqual(userSession.userId, userId)
        XCTAssertEqual(userSession.username, username)
        XCTAssertEqual(userSession.currencyId, currencyId)
        XCTAssertEqual(userSession.password, password)
    }
    
    public func testPasswordSetForSameUser() {
        // given
        let userId   = 0
        let password = "\(Int.random(in: 0...1000))"
        userSession.set(userId: userId, username: "", sessionId: "", currencyId: nil, password: password)
        
        // when
        userSession.set(userId: 0, username: "", sessionId: "", currencyId: nil, password: nil)
        
        // than
        XCTAssertEqual(userSession.password, password)
    }
    
    public func testActions() {
        // given
        var isLoggedInSet = false
        var isLogoutSet = false
        var isFieldsSet = false
        var isRemovedSet = false
        
        _ = userSession.action.subscribe(onNext: { action in
            switch action {
            case .authentication(let isLoggedIn): isLoggedIn ? (isLoggedInSet = true) : (isLogoutSet = true)
            case .fields: isFieldsSet = true
            case .removed: isRemovedSet = true
            }
        })
        
        // when
        userSession.login()
        userSession.logout()
        userSession.set(userId: 0, username: "", sessionId: "", currencyId: nil, password: nil)
        userSession.remove()
        
        // than
        XCTAssertEqual(isLoggedInSet, true)
        XCTAssertEqual(isLogoutSet, true)
        XCTAssertEqual(isFieldsSet, true)
        XCTAssertEqual(isRemovedSet, true)
    }
}
