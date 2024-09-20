//
//  DetailViewModel.swift
//  MoneyBox
//
//  Created by Olly Ives on 18/09/2024.
//

import Foundation
import Networking

class DetailViewModel {
    private let account: ProductResponse
    private let dataProvider: DataProviderLogic
    private(set) var currentMoneyboxValue: Double {
        didSet {
            updateUI?()
        }
    }
    
    var updateUI: (() -> Void)?
    var showAlert: ((String, String, Bool) -> Void)?
    
    init(account: ProductResponse, dataProvider: DataProviderLogic = DataProvider()) {
        self.account = account
        self.dataProvider = dataProvider
        self.currentMoneyboxValue = account.moneybox ?? 0
    }
    
    // Return the account's name, marking it as a cash box if it is one
    var accountName: String {
        let baseName = account.product?.friendlyName ?? "Unknown"
        return account.isCashBox == true ? "\(baseName) (Cash Box)" : baseName
    }
    
    // Return the plan value formatted as a currency
    var planValue: String {
        return String(format: "£%.2f", account.planValue ?? 0)
    }
    
    // Return the moneybox value formatted as a currency
    var moneyboxValue: String {
        return String(format: "£%.2f", currentMoneyboxValue)
    }
    
    // Method to add £10 to the moneybox (or 1000 pence)
    func addMoney() {
        
        let request = OneOffPaymentRequest(amount: 1000, investorProductID: account.id ?? 0)
        
        // Call the dataProvider's addMoney method to perform the network request
        dataProvider.addMoney(request: request) { [weak self] result in
            switch result {
            case .success(let response):
                if let newMoneyboxValue = response.moneybox {
                    self?.currentMoneyboxValue = newMoneyboxValue
                    self?.showAlert?("Success", "Successfully added £10 to your Moneybox. New value: £\(String(format: "%.2f", newMoneyboxValue))", false)
                } else {
                    self?.showAlert?("Error", "Failed to update Moneybox value", true)
                }
            case .failure(let error):
                self?.showAlert?("Error", error.localizedDescription, true)
            }
        }
    }
}

// Struct for handling error responses from the API
struct ErrorResponse: Codable {
    let name: String
    let message: String
}
