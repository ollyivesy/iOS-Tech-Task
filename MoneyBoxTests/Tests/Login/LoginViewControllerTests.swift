//
//  LoginViewControllerTests.swift
//  MoneyBoxTests
//
//  Created by Olly Ives on 20/09/2024.
//

import XCTest
@testable import MoneyBox
@testable import Networking

class LoginViewControllerTests: XCTestCase {
    var sut: LoginViewController!
    var mockViewModel: MockLoginViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockViewModel = MockLoginViewModel()
        sut = LoginViewController(viewModel: mockViewModel)
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
        mockViewModel = nil
        try super.tearDownWithError()
    }

    func testLoginButtonTapped() {
        // Given
        sut.loginView.emailTextField.text = "test@example.com"
        sut.loginView.passwordTextField.text = "password123"

        // When
        sut.loginView.loginButton.sendActions(for: .touchUpInside)

        // Then
        XCTAssertEqual(mockViewModel.loginCalledCount, 1)
        XCTAssertEqual(mockViewModel.lastEmail, "test@example.com")
        XCTAssertEqual(mockViewModel.lastPassword, "password123")
    }

    func testUpdateLoadingState() {
        // When
        sut.updateLoadingState(true)

        // Then
        XCTAssertFalse(sut.loginView.loginButton.isEnabled)

        // When
        sut.updateLoadingState(false)

        // Then
        XCTAssertTrue(sut.loginView.loginButton.isEnabled)
    }

    func testNavigateToMainScreen() {
        // Given
        let navigationController = UINavigationController(rootViewController: sut)

        // When
        sut.navigateToMainScreen()

        // Then
        let expectation = XCTestExpectation(description: "Navigation completed")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(navigationController.topViewController is AccountsViewController)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}

class MockLoginViewModel: LoginViewModel {
    var loginCalledCount = 0
    var lastEmail: String?
    var lastPassword: String?

    override func login(email: String, password: String) {
        loginCalledCount += 1
        lastEmail = email
        lastPassword = password
        
        // Simulate successful login
        isLoggedIn.value = true
        userName.value = "Test User"
    }
}
