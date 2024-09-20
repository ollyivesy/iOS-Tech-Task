//
//  DetailView.swift
//  MoneyBox
//
//  Created by Olly Ives on 18/09/2024.
//

import UIKit

class DetailView: UIView {
    let stackView = UIStackView()
    let containerView = UIView()
    let nameLabel = UILabel()
    let planValueLabel = UILabel()
    let moneyboxLabel = UILabel()
    let addMoneyButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupContainerView()
        setupStackView()
        setupAddMoneyButton()
        setupConstraints()
    }
    
    private func setupContainerView() {
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.gray.cgColor
        containerView.layer.cornerRadius = 8
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
    }
    
    // Set up the stackView that holds the nameLabel, planValueLabel, and moneyboxLabel
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackView)
        
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        // Add the labels to the stackView
        [nameLabel, planValueLabel, moneyboxLabel].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    private func setupAddMoneyButton() {
        addMoneyButton.setTitle("Add £10", for: .normal)
        addMoneyButton.layer.cornerRadius = 8
        addMoneyButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(addMoneyButton)
    }
    
    // Set up AutoLayout constraints for the views
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            containerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            
            addMoneyButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 40),
            addMoneyButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addMoneyButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),  // Button width is 60% of the view's width
            addMoneyButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // Configure the view with data from the ViewModel
    func configure(with viewModel: DetailViewModel?) {
        guard let viewModel = viewModel else { return }
        nameLabel.text = viewModel.accountName
        planValueLabel.text = "Plan Value: \(viewModel.planValue)"
        moneyboxLabel.text = "Moneybox: \(viewModel.moneyboxValue)"
    }
    
    // Update colors for light/dark mode
    func updateColors(isDarkMode: Bool) {
        backgroundColor = isDarkMode ? .black : .white
        [nameLabel, planValueLabel, moneyboxLabel].forEach { $0.textColor = isDarkMode ? .white : .black }
        addMoneyButton.backgroundColor = isDarkMode ? .white : .systemBlue
        addMoneyButton.setTitleColor(isDarkMode ? .black : .white, for: .normal)
        containerView.layer.borderColor = isDarkMode ? UIColor.white.cgColor : UIColor.gray.cgColor
    }
}
