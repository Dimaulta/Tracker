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
        contentView.backgroundColor = UIColor.clear
        contentView.isUserInteractionEnabled = true // Добавляю это
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.font = UIFont(name: "SFPro-Bold", size: 19) ?? UIFont.boldSystemFont(ofSize: 19)
        headerLabel.textColor = UIColor(named: "BlackDay")
        headerLabel.textAlignment = .left
        contentView.addSubview(headerLabel)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 16
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.clear.cgColor
        contentView.addSubview(containerView)
        
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.font = UIFont.systemFont(ofSize: 16)
        emojiLabel.textAlignment = .left
        containerView.addSubview(emojiLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont(name: "SFPro-Medium", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .medium)
        nameLabel.textColor = UIColor.white
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 2
        
        // Добавляем line-height 18px согласно Figma
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 18.0 / 12.0 // line-height = 18px при font-size = 12px
        nameLabel.attributedText = NSAttributedString(
            string: nameLabel.text ?? "",
            attributes: [
                .paragraphStyle: paragraphStyle,
                .font: nameLabel.font ?? UIFont.systemFont(ofSize: 12, weight: .medium),
                .foregroundColor: UIColor.white
            ]
        )
        
        containerView.addSubview(nameLabel)
        
        daysLabel.translatesAutoresizingMaskIntoConstraints = false
        daysLabel.font = UIFont(name: "SFPro-Medium", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .medium)
        daysLabel.textColor = UIColor(named: "BlackDay")
        daysLabel.textAlignment = .left
        contentView.addSubview(daysLabel)
        
        completionButton.translatesAutoresizingMaskIntoConstraints = false
        completionButton.layer.cornerRadius = 17
        // completionButton.layer.borderWidth = 2
        // completionButton.layer.borderColor = UIColor.red.cgColor
        completionButton.isUserInteractionEnabled = true
        completionButton.layer.zPosition = 999 // Увеличиваю z-index
        
        // Добавляем gesture recognizer вместо target-action
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(completionButtonTapped))
        completionButton.addGestureRecognizer(tapGesture)
        
        print("🔍 Debug: Кнопка настроена, gesture добавлен")
        contentView.addSubview(completionButton)
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            headerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            headerLabel.heightAnchor.constraint(equalToConstant: 18),
            
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor), // Убрал отступ
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor), // Убрал отступ
            containerView.heightAnchor.constraint(equalToConstant: 70),
            
            emojiLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            
            nameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            // Счётчик: 16px от нижнего края цветной области, 12px от левого края цветной области
            daysLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 16),
            daysLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            
            // Кнопка под зелёной областью справа
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
        print("🔍 Debug: completionButton.alpha = \(completionButton.alpha)")
        print("🔍 Debug: completionButton.isHidden = \(completionButton.isHidden)")
        print("🔍 Debug: contentView.isUserInteractionEnabled = \(contentView.isUserInteractionEnabled)")
        print("🔍 Debug: gesture recognizer работает!")
        
        guard let tracker = tracker else { 
            print("🔍 Debug: tracker is nil")
            return 
        }
        print("🔍 Debug: Вызываю onCompletionToggled для трекера '\(tracker.name)'")
        print("🔍 Debug: onCompletionToggled = \(onCompletionToggled != nil)")
        onCompletionToggled?(tracker)
        print("🔍 Debug: onCompletionToggled выполнен")
    }
    
    func configure(with tracker: Tracker, selectedDate: Date, isCompleted: Bool, completedCount: Int) {
        self.tracker = tracker
        self.selectedDate = selectedDate
        
        // Убираем заголовок категории из ячейки
        headerLabel.isHidden = true
        
        emojiLabel.text = tracker.emoji
        
        nameLabel.text = tracker.name
        
        // Обновляем attributedText с правильным line-height
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 18.0 / 12.0 // line-height = 18px при font-size = 12px
        nameLabel.attributedText = NSAttributedString(
            string: tracker.name,
            attributes: [
                .paragraphStyle: paragraphStyle,
                .font: nameLabel.font ?? UIFont.systemFont(ofSize: 12, weight: .medium),
                .foregroundColor: UIColor.white
            ]
        )
        
        let dayText = getDayText(for: completedCount)
        daysLabel.text = "\(completedCount) \(dayText)"
        
        containerView.backgroundColor = UIColor(named: tracker.color) ?? UIColor(named: "Green")
        
        updateCompletionButton(isCompleted: isCompleted)
        
        print("🔍 Debug: Ячейка настроена для трекера '\(tracker.name)', onCompletionToggled = \(onCompletionToggled != nil)")
        print("🔍 Debug: completionButton.frame после configure = \(completionButton.frame)")
        print("🔍 Debug: contentView.frame = \(contentView.frame)")
        print("🔍 Debug: containerView.frame = \(containerView.frame)")
        print("🔍 Debug: daysLabel.frame = \(daysLabel.frame)")
        print("🔍 Debug: Высота ячейки = 90, containerView = 70, отступ = 8, кнопка = 34")
        print("🔍 Debug: Общая высота = 70 + 8 + 34 = 112 > 90!")
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
        print("🔍 Debug: updateCompletionButton вызван, isCompleted = \(isCompleted)")
        print("🔍 Debug: tracker?.color = \(tracker?.color ?? "nil")")
        
        // completionButton.layer.cornerRadius = 17
        // completionButton.layer.borderWidth = 2
        // completionButton.layer.borderColor = UIColor.red.cgColor
        
        let cellColor = UIColor(named: tracker?.color ?? "Green") ?? UIColor.systemGreen
        print("🔍 Debug: cellColor = \(cellColor)")
        
        if isCompleted {
            // Используем текст "✓" вместо изображения для гарантированно белого цвета
            completionButton.setImage(nil, for: .normal)
            completionButton.setTitle("✓", for: .normal)
            completionButton.setTitleColor(UIColor.white, for: .normal)
            completionButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold) // Галочка 12x12px
            completionButton.backgroundColor = cellColor.withAlphaComponent(0.3) // Прозрачность 30%
            completionButton.alpha = 1.0
            print("🔍 Debug: Установлена галочка текстом, backgroundColor = \(completionButton.backgroundColor?.description ?? "nil")")
        } else {
            // Используем текст "+" вместо изображения
            completionButton.setImage(nil, for: .normal)
            completionButton.setTitle("+", for: .normal)
            completionButton.setTitleColor(UIColor.white, for: .normal)
            completionButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light) // Плюсик 20px
            completionButton.backgroundColor = cellColor // Кружок в цвет привычки
            completionButton.alpha = 1.0
            print("🔍 Debug: Установлен плюсик текстом, backgroundColor = \(completionButton.backgroundColor?.description ?? "nil")")
        }
        
        completionButton.isHidden = false
        
        // Принудительно обновляем layout
        completionButton.layoutIfNeeded()
        contentView.layoutIfNeeded()
        
        print("🔍 Debug: Кнопка настроена, frame = \(completionButton.frame)")
        print("🔍 Debug: Кнопка isUserInteractionEnabled = \(completionButton.isUserInteractionEnabled)")
        print("🔍 Debug: Кнопка zPosition = \(completionButton.layer.zPosition)")
        print("🔍 Debug: Кнопка alpha = \(completionButton.alpha)")
        print("🔍 Debug: Кнопка isHidden = \(completionButton.isHidden)")
        print("🔍 Debug: Кнопка image = \(completionButton.image(for: .normal) != nil)")
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