//
//  AccountCellTests.swift
//  MoneyBoxUITests
//
//  Created by Olly Ives on 20/09/2024.
//

import XCTest
@testable import MoneyBox
@testable import Networking

class AccountCellTests: XCTestCase {
    var sut: AccountCell!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = AccountCell(style: .default, reuseIdentifier: "AccountCell")
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testInitialization() {
        XCTAssertNotNil(sut.nameLabel)
        XCTAssertNotNil(sut.planValueLabel)
        XCTAssertNotNil(sut.moneyboxLabel)
        XCTAssertNotNil(sut.arrowImageView)
    }

    func testUpdateColors() {
        sut.updateColors(isDarkMode: true)
        XCTAssertEqual(sut.containerView.backgroundColor, .darkGray)
        XCTAssertEqual(sut.nameLabel.textColor, .white)
        XCTAssertEqual(sut.planValueLabel.textColor, .white)
        XCTAssertEqual(sut.moneyboxLabel.textColor, .white)
        XCTAssertEqual(sut.arrowImageView.tintColor, .white)

        sut.updateColors(isDarkMode: false)
        XCTAssertEqual(sut.containerView.backgroundColor, .lightGray)
        XCTAssertEqual(sut.nameLabel.textColor, .black)
        XCTAssertEqual(sut.planValueLabel.textColor, .black)
        XCTAssertEqual(sut.moneyboxLabel.textColor, .black)
        XCTAssertEqual(sut.arrowImageView.tintColor, .darkGray)
    }

    func testSelectionAndHighlight() {
        sut.setSelected(true, animated: false)
        XCTAssertEqual(sut.containerView.backgroundColor, .darkGray)

        sut.setSelected(false, animated: false)
        XCTAssertEqual(sut.containerView.backgroundColor, .lightGray)

        sut.setHighlighted(true, animated: false)
        XCTAssertEqual(sut.containerView.backgroundColor, .darkGray)

        sut.setHighlighted(false, animated: false)
        XCTAssertEqual(sut.containerView.backgroundColor, .lightGray)
    }
}
