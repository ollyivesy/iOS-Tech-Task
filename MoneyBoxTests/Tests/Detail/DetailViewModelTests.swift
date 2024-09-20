//
//  DetailViewModelTests.swift
//  MoneyBoxTests
//
//  Created by Olly Ives on 20/09/2024.
//

import XCTest
@testable import MoneyBox
@testable import Networking

class DetailViewModelTests: XCTestCase {
    var sut: DetailViewModel!
    var mockDataProvider: MockDataProvider!
    var mockAccount: ProductResponse!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockDataProvider = MockDataProvider()
        
        // Use StubData to get mock account data
        let expectation = self.expectation(description: "Load mock data")
        StubData.read(file: "Accounts") { (result: Result<AccountResponse, Error>) in
            switch result {
            case .success(let accountResponse):
                self.mockAccount = accountResponse.productResponses?.first
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Failed to load mock data: \(error)")
            }
        }
        wait(for: [expectation], timeout: 5.0)
        
        XCTAssertNotNil(mockAccount, "Failed to load mock account data")
        sut = DetailViewModel(account: mockAccount, dataProvider: mockDataProvider)
    }

    override func tearDownWithError() throws {
        sut = nil
        mockDataProvider = nil
        mockAccount = nil
        try super.tearDownWithError()
    }

    func testInitialization() {
        XCTAssertEqual(sut.accountName, "Stocks & Shares ISA")
        XCTAssertEqual(sut.planValue, "£10526.09")
        XCTAssertEqual(sut.moneyboxValue, "£570.00")
    }

    func testAddMoneySuccess() {
        // Given
        let expectation = self.expectation(description: "Add money success")
        var showAlertCalled = false
        var alertTitle: String?
        var alertMessage: String?
        var showWebsiteLink: Bool?

        sut.showAlert = { title, message, showLink in
            showAlertCalled = true
            alertTitle = title
            alertMessage = message
            showWebsiteLink = showLink
            expectation.fulfill()
        }

        // When
        sut.addMoney()

        // Then
        waitForExpectations(timeout: 5.0, handler: nil)
        XCTAssertTrue(showAlertCalled)
        XCTAssertEqual(alertTitle, "Success")
        XCTAssertEqual(alertMessage, "Successfully added £10 to your Moneybox. New value: £580.00")
        XCTAssertFalse(showWebsiteLink ?? true)
        XCTAssertEqual(sut.currentMoneyboxValue, 580.00)
    }

    func testAddMoneyFailure() {
        // Given
        let expectation = self.expectation(description: "Add money failure")
        var showAlertCalled = false
        var alertTitle: String?
        var alertMessage: String?
        var showWebsiteLink: Bool?

        sut.showAlert = { title, message, showLink in
            showAlertCalled = true
            alertTitle = title
            alertMessage = message
            showWebsiteLink = showLink
            expectation.fulfill()
        }

        mockDataProvider.shouldFail = true

        // When
        sut.addMoney()

        // Then
        waitForExpectations(timeout: 5.0, handler: nil)
        XCTAssertTrue(showAlertCalled)
        XCTAssertEqual(alertTitle, "Error")
        XCTAssertEqual(alertMessage, "Failed to add money")
        XCTAssertTrue(showWebsiteLink ?? false)
        XCTAssertEqual(sut.currentMoneyboxValue, 570.00)
    }
}
