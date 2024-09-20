//
//  LoginViewController.swift
//  MoneyBox
//
//  Created by Zeynep Kara on 16.01.2022.
//

import UIKit
import Networking

class LoginViewController: UIViewController {
    let loginView: LoginView
    let viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel = LoginViewModel()) {
        self.viewModel = viewModel
        self.loginView = LoginView()
        super.init(nibName: nil, bundle: nil)
    }
    
    // Required initializer for loading from storyboard
    required init?(coder: NSCoder) {
        self.viewModel = LoginViewModel()
        self.loginView = LoginView()
        super.init(coder: coder)
    }
    
    // Load the custom login view
    override func loadView() {
        view = loginView
    }
    
    // Setup after the view has loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings() // Setup bindings for reactive updates
    }
    
    func setupBindings() {
        // Bind login button action
        loginView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        // Bind loading state to update the button's enabled state
        viewModel.isLoading.bind { [weak self] isLoading in
            self?.updateLoadingState(isLoading)
        }
        
        // Bind error messages to show alerts when errors occur
        viewModel.error.bind { [weak self] error in
            if let error = error {
                self?.showError(error)
            }
        }
        
        // Bind login status to go to the main screen if logged in
        viewModel.isLoggedIn.bind { [weak self] isLoggedIn in
            if isLoggedIn {
                self?.navigateToMainScreen()
            }
        }
    }
    
    @objc func loginButtonTapped() {
        guard let email = loginView.emailTextField.text,
              let password = loginView.passwordTextField.text else {
            return // Do nothing if fields are empty
        }
        
        // Call the login function in the view model
        viewModel.login(email: email, password: password)
    }
    
    // Update loading state based on the view model
    func updateLoadingState(_ isLoading: Bool) {
        loginView.loginButton.isEnabled = !isLoading // Disable button when loading
    }
    
    func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil) // Present the alert
    }
    
    // Navigate to the accounts view after successful login
    func navigateToMainScreen() {
        let accountsViewModel = AccountsViewModel()
        accountsViewModel.userName.value = viewModel.userName.value // Pass user name
        let accountsVC = AccountsViewController(viewModel: accountsViewModel)
        navigationController?.setViewControllers([accountsVC], animated: true) // Transition to accounts view
    }
}
