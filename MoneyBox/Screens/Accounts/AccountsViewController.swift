//
//  AccountsViewController.swift
//  MoneyBox
//
//  Created by Olly Ives on 17/09/2024.
//

import UIKit
import Networking

class AccountsViewController: UIViewController {
    let accountsView = AccountsView()
    let viewModel: AccountsViewModel
    let loadingIndicator = UIActivityIndicatorView(style: .large) // Loading icon
    
    init(viewModel: AccountsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = accountsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.fetchAccounts()
        showLoadingIndicator() // Show spinner while loading
        
        // Setup buttons for darkmode toggle and logging out
        accountsView.darkModeToggleButton.addTarget(self, action: #selector(toggleDarkMode), for: .touchUpInside)
        accountsView.logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
    }
    
    func setupUI() {
        navigationItem.title = ""
        accountsView.tableView.register(AccountCell.self, forCellReuseIdentifier: "AccountCell")
        accountsView.tableView.dataSource = self
        accountsView.tableView.delegate = self
        accountsView.tableView.separatorStyle = .none
        accountsView.tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        accountsView.updateGreeting(name: viewModel.userName.value) // Set greeting
        
        setupLoadingIndicator() // Setup spinners layout
        updateAppearance()
    }
    
    @objc func toggleDarkMode() {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        feedbackGenerator.impactOccurred() // Provide haptic feedback
        isDarkMode.toggle()
    }
    
    func updateAppearance() {
        // Update colors in the view and table based on dark mode
        accountsView.updateColors(isDarkMode: isDarkMode)
        accountsView.tableView.reloadData()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = isDarkMode ? .dark : .light
        }
    }
    
    func setupBindings() {
        // Bind accounts to the table view
        viewModel.accounts.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.accountsView.tableView.reloadData()
                self?.hideLoadingIndicator()
            }
        }
        
        // Bind total plan value to be displayed
        viewModel.totalPlanValue.bind { [weak self] value in
            DispatchQueue.main.async {
                self?.accountsView.updateTotalPlanValue(value)
            }
        }
        
        // Bind the username to the greeting label
        viewModel.userName.bind { [weak self] name in
            DispatchQueue.main.async {
                self?.accountsView.updateGreeting(name: name)
            }
        }
        
        // Bind errors to show an alert if an error occurs
        viewModel.error.bind { [weak self] error in
            if let error = error {
                self?.hideLoadingIndicator()
                self?.showError(error)
            }
        }
    }
    
    // Show loading spinner
    func showLoadingIndicator() {
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
    }
    
    // Hide loading spinner
    func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
    }
    
    // Setup spinner in the center of view
    func setupLoadingIndicator() {
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    var isDarkMode = false {
        didSet {
            updateAppearance() // Update the appearance when mode changes
        }
    }
    
    @objc func logoutTapped() {
        // Haptic feedback on logout
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.impactOccurred()
        
        Authentication.token = nil // Clear token
        
        // Navigate to login screen
        let loginViewModel = LoginViewModel()
        let loginVC = LoginViewController(viewModel: loginViewModel)
        let navController = UINavigationController(rootViewController: loginVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }
}

extension AccountsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.accounts.value.count
    }
    
    // Configure each cell with account data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath) as! AccountCell
        let account = viewModel.accounts.value[indexPath.row]
        cell.configure(with: account)
        cell.updateColors(isDarkMode: isDarkMode)
        return cell
    }
    
    // Set row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    // Handle cell selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        feedbackGenerator.impactOccurred() // Haptic feedback on selection
        
        // Temporarily show selection color on the cell
        if let cell = tableView.cellForRow(at: indexPath) as? AccountCell {
            cell.setSelected(true, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                cell.setSelected(false, animated: true)
            }
        }
        
        // Navigate to account detail view
        let account = viewModel.accounts.value[indexPath.row]
        let detailViewModel = DetailViewModel(account: account)
        let detailViewController = DetailViewController(viewModel: detailViewModel, isDarkMode: isDarkMode)
        
        // Present detail view as a page sheet
        let nav = UINavigationController(rootViewController: detailViewController)
        nav.modalPresentationStyle = .pageSheet
        
        if let sheet = nav.sheetPresentationController {
            sheet.largestUndimmedDetentIdentifier = .large
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        
        present(nav, animated: true, completion: nil)
    }
}
