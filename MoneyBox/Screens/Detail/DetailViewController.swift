//
//  DetailViewController.swift
//  MoneyBox
//
//  Created by Olly Ives on 18/09/2024.
//

import UIKit
import SafariServices

class DetailViewController: UIViewController {
    private let detailView: DetailView
    private let viewModel: DetailViewModel
    
    init(viewModel: DetailViewModel, isDarkMode: Bool) {
        self.viewModel = viewModel
        self.detailView = DetailView()
        super.init(nibName: nil, bundle: nil)
        
        // Update view colors based on the dark mode state
        self.detailView.updateColors(isDarkMode: isDarkMode)
    }
    
    // Initializer when using storyboards
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    // Configure the UI elements, including the title and button actions
    private func setupUI() {
        title = viewModel.accountName
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(dismissSheet))
        detailView.addMoneyButton.addTarget(self, action: #selector(addMoneyTapped), for: .touchUpInside)
    }
    
    // Bind the ViewModel's outputs to the view
    private func bindViewModel() {
        viewModel.updateUI = { [weak self] in
            self?.detailView.configure(with: self?.viewModel)
        }
        // Bind the ViewModel's alert callback to show alerts
        viewModel.showAlert = { [weak self] (title, message, showWebsiteLink) in
            self?.showAlert(title: title, message: message, showWebsiteLink: showWebsiteLink)
        }
        viewModel.updateUI?()
    }
    
    // Dismiss the view controller when the "Close" button is selected
    @objc private func dismissSheet() {
        // Give haptic feedback
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        feedbackGenerator.impactOccurred()
        
        dismiss(animated: true, completion: nil)
    }
    
    // Handle "Add Money" button tap event
    @objc private func addMoneyTapped() {
        // Give haptic feedback
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.impactOccurred()
        
        viewModel.addMoney()
    }
    
    // Display an alert dialog with optional MoneyBox website link
    private func showAlert(title: String, message: String, showWebsiteLink: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // If showWebsiteLink is true, add an action to open the Moneybox website
        if showWebsiteLink {
            alert.addAction(UIAlertAction(title: "Visit Moneybox Website", style: .default, handler: { [weak self] _ in
                self?.openMoneyboxWebsite()
            }))
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    // Open the Moneybox website in Safari
    private func openMoneyboxWebsite() {
        if let url = URL(string: "https://www.moneyboxapp.com") {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
    }
}
