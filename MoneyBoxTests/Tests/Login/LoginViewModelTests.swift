//
//  LoginViewModelTests.swift
//  MoneyBoxTests
//
//  Created by Olly Ives on 19/09/2024.
//

import XCTest
@testable import MoneyBox
@testable import Networking

class LoginViewModelTests: XCTestCase {
    var sut: LoginViewModel!
    var mockDataProvider: MockDataProvider!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockDataProvider = MockDataProvider()
        sut = LoginViewModel(dataProvider: mockDataProvider)
    }

    override func tearDownWithError() throws {
        sut = nil
        mockDataProvider = nil
        try super.tearDownWithError()
    }

    func testLoginSuccess() {
        // Given
        let expectation = self.expectation(description: "Login success")
        var isLoggedInValue = false
        var userNameValue = ""

        sut.isLoggedIn.bind { isLoggedIn in
            isLoggedInValue = isLoggedIn
        }

        sut.userName.bind { userName in
            userNameValue = userName
            expectation.fulfill()
        }

        // When
        sut.login(email: "test+ios@moneyboxapp.com", password: "thisIsATestPassword")

        // Then
        waitForExpectations(timeout: 5.0, handler: nil)
        XCTAssertTrue(isLoggedInValue)
        XCTAssertEqual(userNameValue, "Michael Jordan")
        XCTAssertEqual(Authentication.token, "GuQfJPpjUyJH10Og+hS9c0ttz4q2ZoOnEQBSBP2eAEs=")
    }

    func testLoginFailure() {
        // Given
        let expectation = self.expectation(description: "Login failure")
        expectation.assertForOverFulfill = false
        var errorValue: Error?

        sut.error.bind { error in
            errorValue = error
            expectation.fulfill()
        }

        mockDataProvider.shouldFail = true

        // When
        sut.login(email: "test+ios@moneyboxapp.com", password: "wrongPassword")

        // Then
        waitForExpectations(timeout: 5.0, handler: nil)
        XCTAssertNotNil(errorValue)
        XCTAssertEqual(errorValue?.localizedDescription, "Login failed")
    }

    func testIsLoadingState() {
        // Given
        let expectation = self.expectation(description: "Loading state changes")
        expectation.expectedFulfillmentCount = 2
        var loadingStates: [Bool] = []

        sut.isLoading.bind { isLoading in
            loadingStates.append(isLoading)
            expectation.fulfill()
        }

        // When
        sut.login(email: "test+ios@moneyboxapp.com", password: "thisIsATestPassword")

        // Then
        waitForExpectations(timeout: 5.0, handler: nil)
        XCTAssertEqual(loadingStates, [true, false])
    }

    func testLoginWithEmptyCredentials() {
        // Given
        let expectation = self.expectation(description: "Login with empty credentials")
        expectation.expectedFulfillmentCount = 3
        var errorMessages: [String] = []

        sut.error.bind { error in
            if let error = error {
                errorMessages.append(error.localizedDescription)
                expectation.fulfill()
            }
        }

        // When
        sut.login(email: "", password: "password")
        sut.login(email: "test@example.com", password: "")
        sut.login(email: "", password: "")

        // Then
        waitForExpectations(timeout: 5.0, handler: nil)
        XCTAssertEqual(errorMessages.count, 3)
        XCTAssertTrue(errorMessages.contains("Email cannot be empty"))
        XCTAssertTrue(errorMessages.contains("Password cannot be empty"))
        XCTAssertTrue(errorMessages.contains("Email and password cannot be empty"))
        XCTAssertFalse(sut.isLoggedIn.value)
        XCTAssertEqual(sut.userName.value, "")
    }
}
