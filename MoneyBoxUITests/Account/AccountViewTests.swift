//
//  AccountViewTests.swift
//  MoneyBoxUITests
//
//  Created by Olly Ives on 20/09/2024.
//

import XCTest
@testable import MoneyBox

class AccountViewTests: XCTestCase {
    var sut: AccountsView!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = AccountsView(frame: CGRect(x: 0, y: 0, width: 320, height: 568))
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testInitialization() {
        XCTAssertNotNil(sut.headerLabel)
        XCTAssertNotNil(sut.greetingLabel)
        XCTAssertNotNil(sut.totalPlanValueLabel)
        XCTAssertNotNil(sut.tableView)
        XCTAssertNotNil(sut.darkModeToggleButton)
        XCTAssertNotNil(sut.logoutButton)
    }

    func testHeaderLabel() {
        XCTAssertEqual(sut.headerLabel.text, "User Accounts")
        XCTAssertEqual(sut.headerLabel.font, UIFont.systemFont(ofSize: 24, weight: .bold))
        XCTAssertEqual(sut.headerLabel.textColor, .white)
    }

    func testUpdateGreeting() {
        sut.updateGreeting(name: "John Doe")
        XCTAssertEqual(sut.greetingLabel.text, "Hello, John Doe!")
    }

    func testUpdateTotalPlanValue() {
        sut.updateTotalPlanValue(1000.50)
        XCTAssertEqual(sut.totalPlanValueLabel.text, "Total Plan Value: £1000.50")
    }

    func testUpdateColors() {
        sut.updateColors(isDarkMode: true)
        XCTAssertEqual(sut.backgroundColor, UIColor(named: "customGreen"))
        XCTAssertEqual(sut.headerLabel.textColor, .white)
        XCTAssertEqual(sut.greetingLabel.textColor, .white)
        XCTAssertEqual(sut.totalPlanValueLabel.textColor, .white)
        XCTAssertEqual(sut.darkModeToggleButton.tintColor, .white)
        XCTAssertEqual(sut.logoutButton.tintColor, .white)

        sut.updateColors(isDarkMode: false)
        XCTAssertEqual(sut.backgroundColor, UIColor(named: "customGreen"))
        XCTAssertEqual(sut.headerLabel.textColor, .black)
        XCTAssertEqual(sut.greetingLabel.textColor, .black)
        XCTAssertEqual(sut.totalPlanValueLabel.textColor, .black)
        XCTAssertEqual(sut.tableView.backgroundColor, .white)
        XCTAssertEqual(sut.darkModeToggleButton.tintColor, .black)
        XCTAssertEqual(sut.logoutButton.tintColor, .black)
    }
}
