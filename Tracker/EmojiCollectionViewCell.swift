//
//  EmojiCollectionViewCell.swift
//  Tracker
//
//  Created by Ульта on 26.07.2025.
//

import UIKit

class EmojiCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    private let emojiLabel = UILabel()
    
    // MARK: - Properties
    static let identifier = "EmojiCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = UIColor.clear
        
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.font = UIFont(name: "SFPro-Bold", size: 32) ?? UIFont.boldSystemFont(ofSize: 32)
        emojiLabel.textAlignment = .center
        emojiLabel.textColor = UIColor(named: "BlackDay")
        contentView.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            emojiLabel.widthAnchor.constraint(equalToConstant: 52),
            emojiLabel.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    func configure(with emoji: String, isSelected: Bool) {
        emojiLabel.text = emoji
        
        if isSelected {
            contentView.backgroundColor = UIColor(named: "Gray")
            contentView.layer.cornerRadius = 8
        } else {
            contentView.backgroundColor = UIColor.clear
            contentView.layer.cornerRadius = 0
        }
    }
}
