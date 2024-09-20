//
//  AccountCell.swift
//  MoneyBox
//
//  Created by Olly Ives on 17/09/2024.
//

import UIKit
import Networking

class AccountCell: UITableViewCell {
    let containerView = UIView()
    let nameLabel = UILabel()
    let planValueLabel = UILabel()
    let moneyboxLabel = UILabel()
    let arrowImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        containerView.backgroundColor = .lightGray
        containerView.layer.cornerRadius = 10
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        [nameLabel, planValueLabel, moneyboxLabel, arrowImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        }
        
        arrowImageView.image = UIImage(systemName: "chevron.right") // Arrow icon on right of cell (In accordance with wireframe)
        arrowImageView.tintColor = .darkGray
        
        // Defining layout constraints for the views
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: -8),
            
            planValueLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            planValueLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            moneyboxLabel.topAnchor.constraint(equalTo: planValueLabel.bottomAnchor, constant: 8),
            moneyboxLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            moneyboxLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            
            arrowImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            arrowImageView.widthAnchor.constraint(equalToConstant: 20),
            arrowImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        [nameLabel, planValueLabel, moneyboxLabel].forEach { $0.textColor = .black }
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
    // Configure the cell with account details
    func configure(with account: ProductResponse) {
        var accountName = account.product?.friendlyName ?? ""
        if account.isCashBox == true {
            accountName += " (Cash Box)"
        }
        nameLabel.text = accountName
        planValueLabel.text = "Plan Value: £\(String(format: "%.2f", account.planValue ?? 0))"
        moneyboxLabel.text = "Moneybox: £\(String(format: "%.2f", account.moneybox ?? 0))"
    }
    
    // Update colors based on light/dark mode
    func updateColors(isDarkMode: Bool) {
        containerView.backgroundColor = isDarkMode ? .darkGray : .lightGray
        nameLabel.textColor = isDarkMode ? .white : .black
        planValueLabel.textColor = isDarkMode ? .white : .black
        moneyboxLabel.textColor = isDarkMode ? .white : .black
        arrowImageView.tintColor = isDarkMode ? .white : .darkGray
    }
    
    // Cell selection animation
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        UIView.animate(withDuration: 0.3) {
            self.containerView.backgroundColor = selected ? .darkGray : .lightGray
        }
    }
    
    // Cell highlight animation
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        UIView.animate(withDuration: 0.3) {
            self.containerView.backgroundColor = highlighted ? .darkGray : .lightGray
        }
    }
}
