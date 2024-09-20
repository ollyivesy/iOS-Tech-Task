//
//  AccountsViewModelTests.swift
//  MoneyBoxTests
//
//  Created by Olly Ives on 20/09/2024.
//

import XCTest
@testable import MoneyBox
@testable import Networking

class AccountsViewModelTests: XCTestCase {
    var sut: AccountsViewModel!
    var mockDataProvider: MockDataProvider!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockDataProvider = MockDataProvider()
        sut = AccountsViewModel(dataProvider: mockDataProvider)
        Authentication.token = "mock_token"
    }

    override func tearDownWithError() throws {
        sut = nil
        mockDataProvider = nil
        Authentication.token = nil
        try super.tearDownWithError()
    }

    func testFetchAccountsSuccess() {
        // Given
        let expectation = self.expectation(description: "Fetch accounts success")
        var accountsValue: [ProductResponse] = []
        var totalPlanValueValue: Double = 0

        sut.accounts.bind { accounts in
            accountsValue = accounts
            expectation.fulfill()
        }

        sut.totalPlanValue.bind { totalPlanValue in
            totalPlanValueValue = totalPlanValue
        }

        // When
        sut.fetchAccounts()

        // Then
        waitForExpectations(timeout: 5.0, handler: nil)
        XCTAssertEqual(accountsValue.count, 2, "Should have 2 accounts")
        XCTAssertEqual(totalPlanValueValue, 15707.08, accuracy: 0.01, "Total plan value should be 15707.08")
        XCTAssertNil(sut.error.value, "Error should be nil")

        // Verify first account details
        let firstAccount = accountsValue[0]
        XCTAssertEqual(firstAccount.id, 8043, "First account ID should be 8043")
        XCTAssertEqual(firstAccount.planValue!, 10526.09, accuracy: 0.01, "First account plan value should be 10526.09")
        XCTAssertEqual(firstAccount.moneybox!, 570.00, accuracy: 0.01, "First account moneybox should be 570.00")
        XCTAssertEqual(firstAccount.product?.friendlyName, "Stocks & Shares ISA", "First account should be a Stocks & Shares ISA")

        // Verify second account details
        let secondAccount = accountsValue[1]
        XCTAssertEqual(secondAccount.id, 8042, "Second account ID should be 8042")
        XCTAssertEqual(secondAccount.planValue!, 5180.990000, accuracy: 0.01, "Second account plan value should be 5180.990000")
        XCTAssertEqual(secondAccount.moneybox!, 470.00, accuracy: 0.01, "Second account moneybox should be 470.00")
        XCTAssertEqual(secondAccount.product?.friendlyName, "Lifetime ISA", "Second account should be a Lifetime ISA")

        XCTAssertTrue(mockDataProvider.fetchProductsCalled, "fetchProducts should have been called")
    }

    func testFetchAccountsFailure() {
        // Given
        let expectation = self.expectation(description: "Fetch accounts failure")
        var errorValue: Error?

        sut.error.bind { error in
            errorValue = error
            expectation.fulfill()
        }

        mockDataProvider.shouldFail = true

        // When
        sut.fetchAccounts()

        // Then
        waitForExpectations(timeout: 5.0, handler: nil)
        XCTAssertNotNil(errorValue, "Error should not be nil")
        XCTAssertEqual(errorValue?.localizedDescription, "Failed to fetch accounts", "Error message should match")
        XCTAssertTrue(sut.accounts.value.isEmpty, "Accounts should be empty")
        XCTAssertEqual(sut.totalPlanValue.value, 0, "Total plan value should be 0")
        XCTAssertTrue(mockDataProvider.fetchProductsCalled, "fetchProducts should have been called")
    }

    func testFetchAccountsWithoutAuthentication() {
        // Given
        let expectation = self.expectation(description: "Fetch accounts without authentication")
        var errorValue: Error?

        sut.error.bind { error in
            errorValue = error
            expectation.fulfill()
        }

        Authentication.token = nil

        // When
        sut.fetchAccounts()

        // Then
        waitForExpectations(timeout: 5.0, handler: nil)
        XCTAssertNotNil(errorValue, "Error should not be nil")
        XCTAssertEqual(errorValue?.localizedDescription, "Not authenticated. Please log in.", "Error message should match")
        XCTAssertTrue(sut.accounts.value.isEmpty, "Accounts should be empty")
        XCTAssertEqual(sut.totalPlanValue.value, 0, "Total plan value should be 0")
        XCTAssertFalse(mockDataProvider.fetchProductsCalled, "fetchProducts should not have been called")
    }
}
