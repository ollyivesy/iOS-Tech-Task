//
//  AccountsViewModel.swift
//  MoneyBox
//
//  Created by Olly Ives on 17/09/2024.
//

import Foundation
import Networking

class AccountsViewModel {
    private let dataProvider: DataProviderLogic
    
    var accounts = Observable<[ProductResponse]>([])
    var error = Observable<Error?>(nil)
    var totalPlanValue = Observable<Double>(0)
    var userName = Observable<String>("")
    
    init(dataProvider: DataProviderLogic = DataProvider()) {
        self.dataProvider = dataProvider
    }
    
    // Function to fetch account data
    func fetchAccounts() {
        // Check if the user is authenticated
        guard Authentication.token != nil else {
            // Set an error message if not authenticated
            error.value = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Not authenticated. Please log in."])
            print("Attempted to fetch accounts without authentication token.")
            return
        }
        
        // Fetch accounts from data provider
        dataProvider.fetchProducts { [weak self] result in
            switch result {
            case .success(let response):
                // If successful update accounts and totalPlanValue
                self?.accounts.value = response.productResponses ?? []
                self?.totalPlanValue.value = response.totalPlanValue ?? 0
                print("Successfully fetched accounts.")
            case .failure(let error):
                // If an error occurs update the error
                self?.error.value = error
                print("Failed to fetch accounts: \(error.localizedDescription)")
            }
        }
    }
}
