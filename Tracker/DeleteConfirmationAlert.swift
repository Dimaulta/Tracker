//
//  DeleteConfirmationAlert.swift
//  Tracker
//
//  Created by Ульта on 14.09.2025.
//

import UIKit

protocol DeleteConfirmationAlertDelegate: AnyObject {
    func didConfirmDelete()
    func didCancelDelete()
}

final class DeleteConfirmationAlert: UIView {
    
    // MARK: - UI Elements
    private let backgroundView = UIView()
    private let alertContainer = UIView()
    private let topSectionContainer = UIView() // Контейнер для текста и кнопки "Удалить"
    private let titleLabel = UILabel()
    private let deleteButton = UIButton(type: .system)
    private let separatorLine = UIView() // Разделительная линия
    private let cancelButton = UIButton(type: .system)
    
    // MARK: - Properties
    weak var delegate: DeleteConfirmationAlertDelegate?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = UIColor.clear
        
        // Размытый фон
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        addSubview(backgroundView)
        
        // Контейнер алерта - белый фон, выезжает снизу
        alertContainer.translatesAutoresizingMaskIntoConstraints = false
        alertContainer.backgroundColor = UIColor.white // Явно белый фон
        alertContainer.layer.cornerRadius = 16
        alertContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // Только верхние углы скруглены
        alertContainer.layer.shadowColor = UIColor.black.cgColor
        alertContainer.layer.shadowOffset = CGSize(width: 0, height: -2)
        alertContainer.layer.shadowRadius = 8
        alertContainer.layer.shadowOpacity = 0.1
        addSubview(alertContainer)
        
        // Контейнер верхней секции с прозрачностью
        topSectionContainer.translatesAutoresizingMaskIntoConstraints = false
        topSectionContainer.backgroundColor = UIColor.white.withAlphaComponent(0.7) // Прозрачность
        topSectionContainer.layer.cornerRadius = 16
        topSectionContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // Только верхние углы скруглены
        alertContainer.addSubview(topSectionContainer)
        
        // Разделительная линия
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        separatorLine.backgroundColor = UIColor.gray.withAlphaComponent(0.3) // Тонкая серая линия
        alertContainer.addSubview(separatorLine)
        
        // Заголовок - по параметрам из скриншота
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Уверены что хотите удалить трекер?"
        titleLabel.font = UIFont(name: "SFProText-Regular", size: 13) ?? UIFont.systemFont(ofSize: 13, weight: .regular)
        titleLabel.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.6) // #3C3C43 60%
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        topSectionContainer.addSubview(titleLabel)
        
        // Кнопка удаления - красная из ассетов
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.setTitle("Удалить", for: .normal)
        deleteButton.setTitleColor(UIColor(named: "Red"), for: .normal)
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        deleteButton.backgroundColor = UIColor.clear
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        topSectionContainer.addSubview(deleteButton)
        
        // Кнопка отмены - синяя как на макете с скруглениями
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("Отмена", for: .normal)
        cancelButton.setTitleColor(UIColor(named: "Blue"), for: .normal) // Синий цвет как на макете
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        cancelButton.backgroundColor = UIColor.white // Белый фон
        cancelButton.layer.cornerRadius = 13 // Скругления 13px
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        alertContainer.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Алерт выезжает снизу экрана с отступами от краев
            alertContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            alertContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            alertContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20), // Отступ от таббара
            alertContainer.heightAnchor.constraint(equalToConstant: 200),
            
            // Верхняя секция с прозрачностью
            topSectionContainer.topAnchor.constraint(equalTo: alertContainer.topAnchor),
            topSectionContainer.leadingAnchor.constraint(equalTo: alertContainer.leadingAnchor),
            topSectionContainer.trailingAnchor.constraint(equalTo: alertContainer.trailingAnchor),
            topSectionContainer.heightAnchor.constraint(equalToConstant: 120),
            
            // Разделительная линия
            separatorLine.topAnchor.constraint(equalTo: topSectionContainer.bottomAnchor),
            separatorLine.leadingAnchor.constraint(equalTo: alertContainer.leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: alertContainer.trailingAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 0.5),
            
            // Заголовок
            titleLabel.topAnchor.constraint(equalTo: topSectionContainer.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: topSectionContainer.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: topSectionContainer.trailingAnchor, constant: -20),
            
            // Кнопка удаления
            deleteButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            deleteButton.leadingAnchor.constraint(equalTo: topSectionContainer.leadingAnchor, constant: 20),
            deleteButton.trailingAnchor.constraint(equalTo: topSectionContainer.trailingAnchor, constant: -20),
            deleteButton.heightAnchor.constraint(equalToConstant: 50),
            deleteButton.bottomAnchor.constraint(equalTo: topSectionContainer.bottomAnchor, constant: -20),
            
            // Кнопка отмены
            cancelButton.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: 16), // Расстояние между кнопками
            cancelButton.leadingAnchor.constraint(equalTo: alertContainer.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: alertContainer.trailingAnchor, constant: -20),
            cancelButton.heightAnchor.constraint(equalToConstant: 50),
            cancelButton.bottomAnchor.constraint(equalTo: alertContainer.bottomAnchor, constant: -20)
        ])
        
        // Добавляем тап на фон для закрытия
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    @objc private func deleteButtonTapped() {
        delegate?.didConfirmDelete()
    }
    
    @objc private func cancelButtonTapped() {
        delegate?.didCancelDelete()
    }
    
    @objc private func backgroundTapped() {
        delegate?.didCancelDelete()
    }
    
    // MARK: - Animation
    func show(in view: UIView) {
        // Добавляем алерт к window, чтобы он был поверх всего включая таббар
        guard let window = view.window ?? UIApplication.shared.windows.first else {
            view.addSubview(self)
            return
        }
        
        window.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: window.topAnchor),
            leadingAnchor.constraint(equalTo: window.leadingAnchor),
            trailingAnchor.constraint(equalTo: window.trailingAnchor),
            bottomAnchor.constraint(equalTo: window.bottomAnchor)
        ])
        
        // Поднимаем алерт над всем контентом включая таббар
        window.bringSubviewToFront(self)
        
        // Начальная позиция - алерт за экраном снизу с учетом отступов
        alertContainer.transform = CGAffineTransform(translationX: 0, y: 220) // Больше отступ для анимации
        backgroundView.alpha = 0
        
        // Анимация появления - выезжает снизу
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut) {
            self.backgroundView.alpha = 1
            self.alertContainer.transform = .identity
        }
    }
    
    func hide(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
            self.backgroundView.alpha = 0
            self.alertContainer.transform = CGAffineTransform(translationX: 0, y: 220)
        } completion: { _ in
            self.removeFromSuperview()
            completion()
        }
    }
}
