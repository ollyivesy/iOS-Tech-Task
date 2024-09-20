//
//  MockClasses.swift
//  MoneyBoxTests
//
//  Created by Olly Ives on 19/09/2024.
//

import Foundation
@testable import Networking

class StubData {
    static func read<V: Decodable>(file: String, callback: @escaping (Result<V, Error>) -> Void) {
        if let path = Bundle(for: StubData.self).path(forResource: file, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let result = try JSONDecoder().decode(V.self, from: data)
                callback(.success(result))
            } catch {
                callback(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "stub decoding error"])))
            }
        } else {
            callback(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "no json file"])))
        }
    }
}

class MockDataProvider: DataProviderLogic {
    var shouldFail = false
    var fetchProductsCalled = false

    func login(request: LoginRequest, completion: @escaping ((Result<LoginResponse, Error>) -> Void)) {
        if shouldFail {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Login failed"])))
        } else {
            StubData.read(file: "LoginSucceed", callback: completion)
        }
    }

    func fetchProducts(completion: @escaping ((Result<AccountResponse, Error>) -> Void)) {
        fetchProductsCalled = true
        if shouldFail {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch accounts"])))
        } else {
            StubData.read(file: "Accounts", callback: completion)
        }
    }

    func addMoney(request: OneOffPaymentRequest, completion: @escaping ((Result<OneOffPaymentResponse, Error>) -> Void)) {
        if shouldFail {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to add money"])))
        } else {
            let response = OneOffPaymentResponse(moneybox: 580.00)
            completion(.success(response))
        }
    }
}
