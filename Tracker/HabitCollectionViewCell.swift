//
//  HabitCollectionViewCell.swift
//  Tracker
//
//  Created by Ульта on 26.07.2025.
//

import UIKit

class HabitCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    private let containerView = UIView()
    private let headerLabel = UILabel() // Заголовок секции
    private let emojiLabel = UILabel()
    private let nameLabel = UILabel()
    private let daysLabel = UILabel()
    private let completionButton = UIButton(type: .system)
    
    // MARK: - Properties
    static let identifier = "HabitCell"
    private var habit: Habit?
    private var selectedDate: Date = Date()
    var onCompletionToggled: ((Habit) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Настройка контейнера
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 16
        containerView.layer.borderWidth = 0.5
        containerView.layer.borderColor = UIColor(named: "Gray")?.withAlphaComponent(0.3).cgColor
        contentView.addSubview(containerView)
        
        // Настройка заголовка - над зеленой областью
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.font = UIFont(name: "SFPro-Bold", size: 19) ?? UIFont.boldSystemFont(ofSize: 19)
        headerLabel.textColor = UIColor(named: "BlackDay")
        headerLabel.textAlignment = .left
        headerLabel.numberOfLines = 1
        
        // Настройка line-height как в макете (18px)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 18.0 / 19.0 // 18px / 19px = 0.947
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
        contentView.addSubview(headerLabel) // Добавляем к contentView, а не к containerView
        
        // Настройка эмодзи - в левый угол
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.font = UIFont.systemFont(ofSize: 16)
        emojiLabel.textAlignment = .center
        emojiLabel.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        emojiLabel.layer.cornerRadius = 12
        emojiLabel.clipsToBounds = true
        containerView.addSubview(emojiLabel)
        
        // Настройка названия привычки - внизу по левому краю
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont(name: "SFPro-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17)
        nameLabel.textColor = UIColor.white
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 2
        containerView.addSubview(nameLabel)
        
        // Настройка дней - по левому краю
        daysLabel.translatesAutoresizingMaskIntoConstraints = false
        daysLabel.font = UIFont(name: "SFPro-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12)
        daysLabel.textColor = UIColor(named: "BlackDay")
        daysLabel.textAlignment = .left
        contentView.addSubview(daysLabel)
        
        // Настройка кнопки завершения
        completionButton.translatesAutoresizingMaskIntoConstraints = false
        completionButton.layer.cornerRadius = 17
        completionButton.layer.borderWidth = 2
        completionButton.layer.borderColor = UIColor.white.cgColor
        completionButton.addTarget(self, action: #selector(completionButtonTapped), for: .touchUpInside)
        contentView.addSubview(completionButton)
        
        NSLayoutConstraint.activate([
            // Заголовок - над зеленой областью
            headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            headerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            // Контейнер - под заголовком
            containerView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 90),
            
            // Эмодзи - в левый угол
            emojiLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            
            // Название привычки - внизу по левому краю
            nameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            // Дни - по левому краю на уровне кнопки
            daysLabel.centerYAnchor.constraint(equalTo: completionButton.centerYAnchor),
            daysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            
            // Кнопка завершения - справа от дней на том же уровне
            completionButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 8),
            completionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            completionButton.widthAnchor.constraint(equalToConstant: 34),
            completionButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    @objc private func completionButtonTapped() {
        guard let habit = habit else { return }
        onCompletionToggled?(habit)
    }
    
    func configure(with habit: Habit, selectedDate: Date) {
        self.habit = habit
        self.selectedDate = selectedDate
        
        // Настройка заголовка
        headerLabel.text = habit.category
        
        // Настройка line-height как в макете (18px)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 18.0 / 19.0 // 18px / 19px = 0.947
        paragraphStyle.alignment = .left
        let attributedString = NSAttributedString(
            string: habit.category,
            attributes: [
                .paragraphStyle: paragraphStyle,
                .font: headerLabel.font ?? UIFont.boldSystemFont(ofSize: 19),
                .foregroundColor: UIColor(named: "BlackDay") ?? UIColor.black
            ]
        )
        headerLabel.attributedText = attributedString
        
        // Настройка эмодзи
        emojiLabel.text = habit.emoji
        
        // Настройка названия привычки
        nameLabel.text = habit.name
        
        // Настройка текста дней
        let completedCount = habit.completedCount
        let dayText = getDayText(for: completedCount)
        daysLabel.text = "\(completedCount) \(dayText)"
        
        // Настройка цвета фона
        containerView.backgroundColor = UIColor(named: "Green") // Используем Green из ассетов
        
        // Обновляем кнопку завершения
        updateCompletionButton()
    }
    
    private func updateCompletionButton() {
        guard let habit = habit else { return }
        
        let isCompleted = habit.isCompleted(for: selectedDate)
        let canBeCompleted = habit.canBeCompleted(for: selectedDate)
        
        // Устанавливаем базовые параметры кнопки
        completionButton.layer.cornerRadius = 17
        completionButton.layer.borderWidth = 2
        completionButton.layer.borderColor = UIColor.white.cgColor
        
        // Получаем цвет ячейки для кнопки
        let cellColor = UIColor(named: "Green") ?? UIColor.systemGreen
        
        if isCompleted {
            // Показываем галочку с прозрачностью 30%
            completionButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            completionButton.tintColor = UIColor.white
            completionButton.backgroundColor = cellColor
            completionButton.alpha = 0.3 // Прозрачность 30%
        } else {
            // Показываем плюс
            completionButton.setImage(UIImage(systemName: "plus"), for: .normal)
            completionButton.tintColor = UIColor.white
            completionButton.backgroundColor = cellColor
            completionButton.alpha = 1.0 // Полная видимость
        }
        
        // Отключаем кнопку для будущих дат
        completionButton.isEnabled = canBeCompleted
        if !canBeCompleted {
            completionButton.alpha = 0.5
        }
        
        // Убеждаемся, что кнопка видна
        completionButton.isHidden = false
        
        // Добавляем отладочную информацию
        print("Кнопка завершения: isHidden = \(completionButton.isHidden), alpha = \(completionButton.alpha), frame = \(completionButton.frame)")
    }
    
    private func getDayText(for count: Int) -> String {
        switch count {
        case 1:
            return "день"
        case 2...4:
            return "дня"
        default:
            return "дней"
        }
    }
} 