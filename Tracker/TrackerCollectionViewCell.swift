//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Ульта on 26.07.2025.
//

import UIKit

class TrackerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    private let containerView = UIView()
    private let headerLabel = UILabel()
    private let emojiLabel = UILabel()
    private let nameLabel = UILabel()
    private let daysLabel = UILabel()
    private let completionButton = UIButton(type: .system)
    
    // MARK: - Properties
    static let identifier = "TrackerCell"
    private var tracker: Tracker?
    private var selectedDate: Date = Date()
    var onCompletionToggled: ((Tracker) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 16
        containerView.layer.borderWidth = 0.5
        containerView.layer.borderColor = UIColor(named: "Gray")?.withAlphaComponent(0.3).cgColor
        contentView.addSubview(containerView)
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.font = UIFont(name: "SFPro-Bold", size: 19) ?? UIFont.boldSystemFont(ofSize: 19)
        headerLabel.textColor = UIColor(named: "BlackDay")
        headerLabel.textAlignment = .left
        headerLabel.numberOfLines = 1
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 18.0 / 19.0
        paragraphStyle.alignment = .left
        let attributedString = NSAttributedString(
            string: headerLabel.text ?? "",
            attributes: [
                .paragraphStyle: paragraphStyle,
                .font: headerLabel.font ?? UIFont.boldSystemFont(ofSize: 19),
                .foregroundColor: UIColor(named: "BlackDay") ?? UIColor.black
            ]
        )
        headerLabel.attributedText = attributedString
        contentView.addSubview(headerLabel)
        
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.font = UIFont.systemFont(ofSize: 16)
        emojiLabel.textAlignment = .center
        emojiLabel.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        emojiLabel.layer.cornerRadius = 12
        emojiLabel.clipsToBounds = true
        containerView.addSubview(emojiLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont(name: "SFPro-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17)
        nameLabel.textColor = UIColor.white
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 2
        containerView.addSubview(nameLabel)
        
        daysLabel.translatesAutoresizingMaskIntoConstraints = false
        daysLabel.font = UIFont(name: "SFPro-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12)
        daysLabel.textColor = UIColor(named: "BlackDay")
        daysLabel.textAlignment = .left
        contentView.addSubview(daysLabel)
        
        completionButton.translatesAutoresizingMaskIntoConstraints = false
        completionButton.layer.cornerRadius = 17
        completionButton.layer.borderWidth = 2
        completionButton.layer.borderColor = UIColor.white.cgColor
        completionButton.addTarget(self, action: #selector(completionButtonTapped), for: .touchUpInside)
        contentView.addSubview(completionButton)
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            headerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            headerLabel.heightAnchor.constraint(equalToConstant: 18),
            
            containerView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            containerView.heightAnchor.constraint(equalToConstant: 90),
            
            emojiLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            
            nameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            daysLabel.centerYAnchor.constraint(equalTo: completionButton.centerYAnchor),
            daysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            
            completionButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 8),
            completionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            completionButton.widthAnchor.constraint(equalToConstant: 34),
            completionButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    @objc private func completionButtonTapped() {
        guard let tracker = tracker else { return }
        onCompletionToggled?(tracker)
    }
    
    func configure(with tracker: Tracker, selectedDate: Date, isCompleted: Bool, completedCount: Int) {
        self.tracker = tracker
        self.selectedDate = selectedDate
        
        headerLabel.text = "Важное"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 18.0 / 19.0
        paragraphStyle.alignment = .left
        let attributedString = NSAttributedString(
            string: "Важное",
            attributes: [
                .paragraphStyle: paragraphStyle,
                .font: headerLabel.font ?? UIFont.boldSystemFont(ofSize: 19),
                .foregroundColor: UIColor(named: "BlackDay") ?? UIColor.black
            ]
        )
        headerLabel.attributedText = attributedString
        
        emojiLabel.text = tracker.emoji
        
        nameLabel.text = tracker.name
        
        let dayText = getDayText(for: completedCount)
        daysLabel.text = "\(completedCount) \(dayText)"
        
        containerView.backgroundColor = UIColor(named: tracker.color) ?? UIColor(named: "Green")
        
        updateCompletionButton(isCompleted: isCompleted)
    }
    
    private func updateCompletionButton(isCompleted: Bool) {
        completionButton.layer.cornerRadius = 17
        completionButton.layer.borderWidth = 2
        completionButton.layer.borderColor = UIColor.white.cgColor
        
        let cellColor = UIColor(named: tracker?.color ?? "Green") ?? UIColor.systemGreen
        
        if isCompleted {
            completionButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            completionButton.tintColor = UIColor.white
            completionButton.backgroundColor = cellColor
            completionButton.alpha = 0.3
        } else {
            completionButton.setImage(UIImage(systemName: "plus"), for: .normal)
            completionButton.tintColor = UIColor.white
            completionButton.backgroundColor = cellColor
            completionButton.alpha = 1.0
        }
        
        completionButton.isHidden = false
    }
    
    private func getDayText(for count: Int) -> String {
        let lastDigit = count % 10
        let lastTwoDigits = count % 100
        
        if lastTwoDigits >= 11 && lastTwoDigits <= 19 {
            return "дней"
        }
        
        switch lastDigit {
        case 1:
            return "день"
        case 2, 3, 4:
            return "дня"
        default:
            return "дней"
        }
    }
} 