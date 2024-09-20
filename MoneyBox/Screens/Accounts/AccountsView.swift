//
//  AccountsView.swift
//  MoneyBox
//
//  Created by Olly Ives on 17/09/2024.
//

import UIKit

class AccountsView: UIView {
    let headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "User Accounts"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        return label
    }()

    let greetingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    
    let totalPlanValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        return label
    }()

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .black
        return tableView
    }()

    let darkModeToggleButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "moon.fill"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Logout", for: .normal)
        button.tintColor = .white
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .darkGray
        
        addSubview(darkModeToggleButton)
        
        addSubview(logoutButton)
        
        addSubview(headerLabel)
        addSubview(greetingLabel)
        addSubview(totalPlanValueLabel)
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: 16),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            greetingLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 8),
            greetingLabel.leadingAnchor.constraint(equalTo: headerLabel.leadingAnchor),
            greetingLabel.trailingAnchor.constraint(equalTo: headerLabel.trailingAnchor),
            
            totalPlanValueLabel.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 8),
            totalPlanValueLabel.leadingAnchor.constraint(equalTo: headerLabel.leadingAnchor),
            totalPlanValueLabel.trailingAnchor.constraint(equalTo: headerLabel.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: totalPlanValueLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            darkModeToggleButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            darkModeToggleButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            darkModeToggleButton.widthAnchor.constraint(equalToConstant: 44),
            darkModeToggleButton.heightAnchor.constraint(equalToConstant: 44),
            
            logoutButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            logoutButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            logoutButton.widthAnchor.constraint(equalToConstant: 60),
            logoutButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func updateGreeting(name: String) {
        greetingLabel.text = "Hello, \(name)!"
    }
    
    func updateTotalPlanValue(_ value: Double) {
        totalPlanValueLabel.text = "Total Plan Value: £\(String(format: "%.2f", value))"
    }
    
    // Update colors based on dark mode
    func updateColors(isDarkMode: Bool) {
        backgroundColor = UIColor(named: "customGreen")
        headerLabel.textColor = isDarkMode ? .white : .black
        greetingLabel.textColor = isDarkMode ? .white : .black
        totalPlanValueLabel.textColor = isDarkMode ? .white : .black
        tableView.backgroundColor = isDarkMode ? .black : .white
        darkModeToggleButton.tintColor = isDarkMode ? .white : .black
        darkModeToggleButton.setImage(UIImage(systemName: isDarkMode ? "sun.max.fill" : "moon.fill"), for: .normal)
        logoutButton.tintColor = isDarkMode ? .white : .black
    }
}
