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
        containerView.layer.borderWidth = 1
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
        completionButton.isUserInteractionEnabled = true
        completionButton.layer.zPosition = 1 // Кнопка поверх других элементов
        print("🔍 Debug: Кнопка настроена, target добавлен")
        contentView.addSubview(completionButton)
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            headerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            headerLabel.heightAnchor.constraint(equalToConstant: 18),
            
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            containerView.heightAnchor.constraint(equalToConstant: 70),
            
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
        print("🔍 Debug: Кнопка нажата!")
        print("🔍 Debug: completionButton.frame = \(completionButton.frame)")
        print("🔍 Debug: completionButton.isUserInteractionEnabled = \(completionButton.isUserInteractionEnabled)")
        
        guard let tracker = tracker else { 
            print("🔍 Debug: tracker is nil")
            return 
        }
        print("🔍 Debug: Вызываю onCompletionToggled для трекера '\(tracker.name)'")
        onCompletionToggled?(tracker)
    }
    
    func configure(with tracker: Tracker, selectedDate: Date, isCompleted: Bool, completedCount: Int) {
        self.tracker = tracker
        self.selectedDate = selectedDate
        
        // Убираем заголовок категории из ячейки
        headerLabel.isHidden = true
        
        emojiLabel.text = tracker.emoji
        
        nameLabel.text = tracker.name
        
        let dayText = getDayText(for: completedCount)
        daysLabel.text = "\(completedCount) \(dayText)"
        
        containerView.backgroundColor = UIColor(named: tracker.color) ?? UIColor(named: "Green")
        
        updateCompletionButton(isCompleted: isCompleted)
        
        print("🔍 Debug: Ячейка настроена для трекера '\(tracker.name)', onCompletionToggled = \(onCompletionToggled != nil)")
        print("🔍 Debug: completionButton.frame после configure = \(completionButton.frame)")
    }
    
    func configure(with category: TrackerCategory, selectedDate: Date, isCompleted: Bool, completedCount: Int) {
        self.selectedDate = selectedDate
        
        // Показываем заголовок категории
        headerLabel.isHidden = false
        headerLabel.text = category.title
        
        // Показываем первый трекер из категории (временно)
        if let firstTracker = category.trackers.first {
            self.tracker = firstTracker
            emojiLabel.text = firstTracker.emoji
            nameLabel.text = firstTracker.name
            containerView.backgroundColor = UIColor(named: firstTracker.color) ?? UIColor(named: "Green")
        }
        
        let dayText = getDayText(for: completedCount)
        daysLabel.text = "\(completedCount) \(dayText)"
        
        updateCompletionButton(isCompleted: isCompleted)
    }
    
    private func updateCompletionButton(isCompleted: Bool) {
        // TODO: Реализовать кнопку плюса и счётчика согласно функционалу и дизайну
        print("🔍 Debug: updateCompletionButton вызван, isCompleted = \(isCompleted)")
        print("🔍 Debug: tracker?.color = \(tracker?.color ?? "nil")")
        
        completionButton.layer.cornerRadius = 17
        completionButton.layer.borderWidth = 2
        completionButton.layer.borderColor = UIColor.white.cgColor
        
        let cellColor = UIColor(named: tracker?.color ?? "Green") ?? UIColor.systemGreen
        print("🔍 Debug: cellColor = \(cellColor)")
        
        if isCompleted {
            let habitPropertyImage = UIImage(named: "habitproperty")
            print("🔍 Debug: habitproperty image = \(habitPropertyImage != nil)")
            completionButton.setImage(habitPropertyImage?.withRenderingMode(.alwaysTemplate), for: .normal)
            completionButton.tintColor = UIColor.white // Галочка белая
            completionButton.backgroundColor = cellColor.withAlphaComponent(0.5) // Светло-зелёная как на макете
            completionButton.alpha = 1.0
            print("🔍 Debug: Установлена галочка, backgroundColor = \(completionButton.backgroundColor?.description ?? "nil")")
        } else {
            let habitPlusImage = UIImage(named: "habitplus")
            print("🔍 Debug: habitplus image = \(habitPlusImage != nil)")
            completionButton.setImage(habitPlusImage?.withRenderingMode(.alwaysTemplate), for: .normal)
            completionButton.tintColor = UIColor.white // Плюсик белый
            completionButton.backgroundColor = cellColor // Кружок в цвет привычки
            completionButton.alpha = 1.0
            print("🔍 Debug: Установлен плюсик, backgroundColor = \(completionButton.backgroundColor?.description ?? "nil")")
        }
        
        completionButton.isHidden = false
        
        // Принудительно обновляем layout
        completionButton.layoutIfNeeded()
        contentView.layoutIfNeeded()
        
        print("🔍 Debug: Кнопка настроена, frame = \(completionButton.frame)")
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