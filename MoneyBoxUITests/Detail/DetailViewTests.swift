//
//  DetailViewTests.swift
//  MoneyBoxUITests
//
//  Created by Olly Ives on 20/09/2024.
//

import XCTest
@testable import MoneyBox

class DetailViewTests: XCTestCase {
    var sut: DetailView!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = DetailView(frame: CGRect(x: 0, y: 0, width: 320, height: 568))
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testInitialization() {
        XCTAssertNotNil(sut.nameLabel)
        XCTAssertNotNil(sut.planValueLabel)
        XCTAssertNotNil(sut.moneyboxLabel)
        XCTAssertNotNil(sut.addMoneyButton)
    }

    func testUpdateColors() {
        sut.updateColors(isDarkMode: true)
        XCTAssertEqual(sut.backgroundColor, .black)
        XCTAssertEqual(sut.nameLabel.textColor, .white)
        XCTAssertEqual(sut.planValueLabel.textColor, .white)
        XCTAssertEqual(sut.moneyboxLabel.textColor, .white)
        XCTAssertEqual(sut.addMoneyButton.backgroundColor, .white)
        XCTAssertEqual(sut.addMoneyButton.titleColor(for: .normal), .black)

        sut.updateColors(isDarkMode: false)
        XCTAssertEqual(sut.backgroundColor, .white)
        XCTAssertEqual(sut.nameLabel.textColor, .black)
        XCTAssertEqual(sut.planValueLabel.textColor, .black)
        XCTAssertEqual(sut.moneyboxLabel.textColor, .black)
        XCTAssertEqual(sut.addMoneyButton.backgroundColor, .systemBlue)
        XCTAssertEqual(sut.addMoneyButton.titleColor(for: .normal), .white)
    }
}
