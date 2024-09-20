//
//  LoginViewModel.swift
//  MoneyBox
//
//  Created by Olly Ives on 17/09/2024.
//

import Foundation
import Networking

// Allows for binding data changes to UI components
class Observable<T> {
    var value: T {
        didSet {
            listener?(value) // Notify listener when value changes
        }
    }
    
    private var listener: ((T) -> Void)? // Closure to handle value updates
    
    init(_ value: T) {
        self.value = value // Initialize with a default value
    }
    
    // Method to bind a closure that will be called when the value changes
    func bind(_ closure: @escaping (T) -> Void) {
        listener = closure // Store the listener closure
    }
}

class LoginViewModel {
    private let dataProvider: DataProviderLogic
    private let sessionManager: SessionManager
    
    // Observable properties for UI binding
    var isLoading = Observable(false) // Indicates loading state
    var error = Observable<Error?>(nil) // Holds error information
    var isLoggedIn = Observable(false) // Indicates if user is logged in
    var userName = Observable<String>("") // Stores user's name
    
    init(dataProvider: DataProviderLogic = DataProvider(), sessionManager: SessionManager = SessionManager()) {
        self.dataProvider = dataProvider
        self.sessionManager = sessionManager
    }
    
    // Handle user login
    func login(email: String, password: String) {
        isLoading.value = true
        error.value = nil
        
        // Validate input fields
        if email.isEmpty && password.isEmpty {
            isLoading.value = false
            error.value = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Email and password cannot be empty"])
            return
        } else if email.isEmpty {
            isLoading.value = false
            error.value = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Email cannot be empty"])
            return
        } else if password.isEmpty {
            isLoading.value = false
            error.value = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Password cannot be empty"])
            return
        }

        // Create login request
        let loginRequest = LoginRequest(email: email, password: password)
        dataProvider.login(request: loginRequest) { [weak self] result in
            self?.isLoading.value = false
            
            // Handle login result
            switch result {
            case .success(let response):
                // Store the user's token and name on successful login
                self?.sessionManager.setUserToken(response.session.bearerToken)
                let firstName = response.user.firstName ?? ""
                let lastName = response.user.lastName ?? ""
                self?.userName.value = "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
                self?.isLoggedIn.value = true // Update login status
            case .failure(let error):
                // Update error if login fails
                self?.error.value = error
            }
        }
    }
}
