//
//  MoneyBoxUITests.swift
//  MoneyBoxUITests
//
//  Created by Olly Ives on 20/09/2024.
//

import XCTest
@testable import MoneyBox

class LoginViewTests: XCTestCase {
    var sut: LoginView!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = LoginView(frame: CGRect(x: 0, y: 0, width: 320, height: 568))
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testInitialization() {
        XCTAssertNotNil(sut.headerLabel)
        XCTAssertNotNil(sut.emailTextField)
        XCTAssertNotNil(sut.passwordTextField)
        XCTAssertNotNil(sut.loginButton)
    }

    func testHeaderLabel() {
        XCTAssertEqual(sut.headerLabel.text, "Welcome! Please Log In")
        XCTAssertEqual(sut.headerLabel.font, UIFont.boldSystemFont(ofSize: 24))
        XCTAssertEqual(sut.headerLabel.textAlignment, .center)
    }

    func testEmailTextField() {
        XCTAssertEqual(sut.emailTextField.placeholder, "Email")
        XCTAssertEqual(sut.emailTextField.backgroundColor, .white)
        XCTAssertEqual(sut.emailTextField.layer.cornerRadius, 8.0)
    }

    func testPasswordTextField() {
        XCTAssertEqual(sut.passwordTextField.placeholder, "Password")
        XCTAssertTrue(sut.passwordTextField.isSecureTextEntry)
        XCTAssertEqual(sut.passwordTextField.backgroundColor, .white)
        XCTAssertEqual(sut.passwordTextField.layer.cornerRadius, 8.0)
    }

    func testLoginButton() {
        XCTAssertEqual(sut.loginButton.titleLabel?.text, "Login")
        XCTAssertEqual(sut.loginButton.backgroundColor, .green)
        XCTAssertEqual(sut.loginButton.titleColor(for: .normal), .white)
        XCTAssertEqual(sut.loginButton.layer.cornerRadius, 20)
    }

    func testBackgroundColor() {
        XCTAssertEqual(sut.backgroundColor, UIColor(named: "customGreyColor"))
    }

    func testLayoutConstraints() {
        sut.layoutIfNeeded()

        XCTAssertEqual(sut.headerLabel.frame.origin.y, 60)
        XCTAssertEqual(sut.stackView.frame.origin.y, sut.headerLabel.frame.maxY + 40)
        XCTAssertEqual(sut.stackView.frame.width, sut.frame.width * 0.8, accuracy: 1.0)
    }
}
