//
//  CategoryTableViewCell.swift
//  Tracker
//
//  Created by Ульта on 30.08.2025.
//

import UIKit

final class CategoryTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let checkmarkImageView = UIImageView()
    
    // MARK: - Properties
    static let identifier = "CategoryCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor(red: 0.90, green: 0.91, blue: 0.92, alpha: 0.30)
        containerView.layer.cornerRadius = 16
        contentView.addSubview(containerView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "SFPro-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17)
        titleLabel.textColor = UIColor(named: "BlackDay")
        titleLabel.numberOfLines = 1
        containerView.addSubview(titleLabel)
        
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        checkmarkImageView.image = UIImage(systemName: "checkmark")
        checkmarkImageView.tintColor = UIColor(named: "Blue")
        checkmarkImageView.contentMode = .scaleAspectFit
        checkmarkImageView.isHidden = true
        containerView.addSubview(checkmarkImageView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 75),
            
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: checkmarkImageView.leadingAnchor, constant: -16),
            
            checkmarkImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            checkmarkImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 24),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    // MARK: - Configuration
    func configure(with category: TrackerCategory, isSelected: Bool) {
        titleLabel.text = category.title
        checkmarkImageView.isHidden = !isSelected
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        checkmarkImageView.isHidden = true
    }
}
