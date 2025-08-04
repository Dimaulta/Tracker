//
//  CreateHabitViewController.swift
//  Tracker
//
//  Created by Ульта on 26.07.2025.
//

import UIKit

class CreateHabitViewController: UIViewController {
    
    // MARK: - UI Elements
    private let titleLabel = UILabel()
    private let nameTextField = UITextField()
    private let categoryContainerView = UIView()
    private let categoryLabel = UILabel()
    private let categoryArrowImageView = UIImageView()
    private let categoryValueLabel = UILabel()
    private let scheduleLabel = UILabel()
    private let scheduleArrowImageView = UIImageView()
    private let scheduleValueLabel = UILabel()
    private let dividerView = UIView()
    private let cancelButton = UIButton(type: .system)
    private let createButton = UIButton(type: .system)
    private let characterLimitLabel = UILabel()
    
    // MARK: - Constraints for animation
    private var categoryLabelTopConstraint: NSLayoutConstraint?
    private var categoryValueLabelTopConstraint: NSLayoutConstraint?
    private var scheduleLabelTopConstraint: NSLayoutConstraint?
    private var scheduleValueLabelTopConstraint: NSLayoutConstraint?
    
    // MARK: - Properties
    private let maxCharacterCount = 38
    private var isFormValid = false {
        didSet {
            updateCreateButtonState()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        setupUI()
        setupConstraints()
        setupKeyboardHandling()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "WhiteDay")
        
        // Настройка заголовка
        setupTitle()
        
        // Настройка поля ввода названия
        setupNameTextField()
        
        // Настройка контейнера категории и расписания
        setupCategoryContainer()
        
        // Настройка кнопок
        setupButtons()
        
        // Настройка лейбла ограничения символов
        setupCharacterLimitLabel()
    }
    
    private func setupTitle() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Новая привычка"
        titleLabel.font = UIFont(name: "SFPro-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = UIColor(named: "BlackDay")
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
    }
    
    private func setupNameTextField() {
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.placeholder = "Введите название трекера"
        nameTextField.font = UIFont(name: "SFPro-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17)
        nameTextField.textColor = UIColor(named: "BlackDay")
        nameTextField.backgroundColor = UIColor(named: "BackgroundDay")
        nameTextField.layer.cornerRadius = 16
        nameTextField.borderStyle = .none
        nameTextField.delegate = self
        
        // Добавляем отступы для текста
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        nameTextField.leftView = paddingView
        nameTextField.leftViewMode = .always
        
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        nameTextField.rightView = rightPaddingView
        nameTextField.rightViewMode = .always
        
        view.addSubview(nameTextField)
    }
    
    private func setupCategoryContainer() {
        categoryContainerView.translatesAutoresizingMaskIntoConstraints = false
        categoryContainerView.backgroundColor = UIColor(named: "BackgroundDay")
        categoryContainerView.layer.cornerRadius = 16
        categoryContainerView.alpha = 1.0
        view.addSubview(categoryContainerView)
        
        // Настройка категории
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.text = "Категория"
        categoryLabel.font = UIFont(name: "SFPro-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17)
        categoryLabel.textColor = UIColor(named: "BlackDay")
        categoryContainerView.addSubview(categoryLabel)
        
        categoryArrowImageView.translatesAutoresizingMaskIntoConstraints = false
        categoryArrowImageView.image = UIImage(named: "next")
        categoryArrowImageView.tintColor = UIColor(named: "Gray")
        categoryContainerView.addSubview(categoryArrowImageView)
        
        // Настройка значения категории
        categoryValueLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryValueLabel.text = "Важное"
        categoryValueLabel.font = UIFont(name: "SFPro-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17)
        categoryValueLabel.textColor = UIColor(named: "Gray")
        categoryValueLabel.isHidden = true
        categoryContainerView.addSubview(categoryValueLabel)
        
        // Настройка разделителя
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        dividerView.backgroundColor = UIColor(named: "Gray")
        categoryContainerView.addSubview(dividerView)
        
        // Настройка расписания
        scheduleLabel.translatesAutoresizingMaskIntoConstraints = false
        scheduleLabel.text = "Расписание"
        scheduleLabel.font = UIFont(name: "SFPro-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17)
        scheduleLabel.textColor = UIColor(named: "BlackDay")
        categoryContainerView.addSubview(scheduleLabel)
        
        scheduleArrowImageView.translatesAutoresizingMaskIntoConstraints = false
        scheduleArrowImageView.image = UIImage(named: "next")
        scheduleArrowImageView.tintColor = UIColor(named: "Gray")
        categoryContainerView.addSubview(scheduleArrowImageView)
        
        // Настройка значения расписания
        scheduleValueLabel.translatesAutoresizingMaskIntoConstraints = false
        scheduleValueLabel.text = "Каждый день"
        scheduleValueLabel.font = UIFont(name: "SFPro-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17)
        scheduleValueLabel.textColor = UIColor(named: "Gray")
        scheduleValueLabel.isHidden = true
        categoryContainerView.addSubview(scheduleValueLabel)
        
        // Добавляем обработчики нажатий
        let categoryTap = UITapGestureRecognizer(target: self, action: #selector(categoryTapped))
        categoryLabel.addGestureRecognizer(categoryTap)
        categoryLabel.isUserInteractionEnabled = true
        
        // Добавляем интерактивность для расписания
        let scheduleTap = UITapGestureRecognizer(target: self, action: #selector(scheduleTapped))
        scheduleLabel.addGestureRecognizer(scheduleTap)
        scheduleLabel.isUserInteractionEnabled = true
    }
    
    private func setupButtons() {
        // Кнопка "Отменить"
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(UIColor(named: "Red"), for: .normal)
        cancelButton.titleLabel?.font = UIFont(name: "SFPro-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium)
        cancelButton.backgroundColor = UIColor.clear
        cancelButton.layer.cornerRadius = 16
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor(named: "Red")?.cgColor
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        // Кнопка "Создать"
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.setTitle("Создать", for: .normal)
        createButton.setTitleColor(UIColor(named: "WhiteDay"), for: .normal)
        createButton.titleLabel?.font = UIFont(name: "SFPro-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium)
        createButton.backgroundColor = UIColor(named: "Gray")
        createButton.layer.cornerRadius = 16
        createButton.isEnabled = false
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        view.addSubview(createButton)
    }
    
    private func setupCharacterLimitLabel() {
        characterLimitLabel.translatesAutoresizingMaskIntoConstraints = false
        characterLimitLabel.text = "Ограничение 38 символов"
        characterLimitLabel.font = UIFont(name: "SFPro-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17)
        characterLimitLabel.textColor = UIColor(named: "Red")
        characterLimitLabel.textAlignment = .center
        characterLimitLabel.isHidden = true
        view.addSubview(characterLimitLabel)
    }
    
    private func setupConstraints() {
        // Создаем констрейнты для анимации
        categoryLabelTopConstraint = categoryLabel.topAnchor.constraint(equalTo: categoryContainerView.topAnchor, constant: 30)
        categoryValueLabelTopConstraint = categoryValueLabel.topAnchor.constraint(equalTo: categoryContainerView.topAnchor, constant: 45) // Чуть ниже "Категории"
        
        scheduleLabelTopConstraint = scheduleLabel.topAnchor.constraint(equalTo: categoryContainerView.topAnchor, constant: 91)
        scheduleValueLabelTopConstraint = scheduleValueLabel.topAnchor.constraint(equalTo: categoryContainerView.topAnchor, constant: 106) // Чуть ниже "Расписания"
        
        // Изначально "Важное" и "Каждый день" скрыты
        categoryValueLabel.isHidden = true
        scheduleValueLabel.isHidden = true
        
        NSLayoutConstraint.activate([
            // Заголовок
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Поле ввода названия
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.widthAnchor.constraint(equalToConstant: 343),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            // Лейбл ограничения символов
            characterLimitLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 8),
            characterLimitLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Контейнер категории и расписания
            categoryContainerView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            categoryContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            categoryContainerView.widthAnchor.constraint(equalToConstant: 343),
            categoryContainerView.heightAnchor.constraint(equalToConstant: 150),
            
            // Категория
            categoryLabelTopConstraint!,
            categoryLabel.leadingAnchor.constraint(equalTo: categoryContainerView.leadingAnchor, constant: 16),
            
            categoryArrowImageView.centerYAnchor.constraint(equalTo: categoryContainerView.topAnchor, constant: 37.5),
            categoryArrowImageView.trailingAnchor.constraint(equalTo: categoryContainerView.trailingAnchor, constant: -16),
            categoryArrowImageView.widthAnchor.constraint(equalToConstant: 24),
            categoryArrowImageView.heightAnchor.constraint(equalToConstant: 24),
            
            // Значение категории - центрируем по вертикали в верхней половине
            categoryValueLabelTopConstraint!,
            categoryValueLabel.leadingAnchor.constraint(equalTo: categoryContainerView.leadingAnchor, constant: 16),
            categoryValueLabel.trailingAnchor.constraint(equalTo: categoryContainerView.trailingAnchor, constant: -40), // Оставляем место для стрелки
            
            // Разделитель
            dividerView.centerYAnchor.constraint(equalTo: categoryContainerView.centerYAnchor),
            dividerView.leadingAnchor.constraint(equalTo: categoryContainerView.leadingAnchor, constant: 16),
            dividerView.trailingAnchor.constraint(equalTo: categoryContainerView.trailingAnchor, constant: -16),
            dividerView.heightAnchor.constraint(equalToConstant: 0.5),
            
            // Расписание
            scheduleLabelTopConstraint!,
            scheduleLabel.leadingAnchor.constraint(equalTo: categoryContainerView.leadingAnchor, constant: 16),
            
            scheduleArrowImageView.centerYAnchor.constraint(equalTo: categoryContainerView.topAnchor, constant: 112.5),
            scheduleArrowImageView.trailingAnchor.constraint(equalTo: categoryContainerView.trailingAnchor, constant: -16),
            scheduleArrowImageView.widthAnchor.constraint(equalToConstant: 24),
            scheduleArrowImageView.heightAnchor.constraint(equalToConstant: 24),
            
            // Значение расписания
            scheduleValueLabelTopConstraint!,
            scheduleValueLabel.leadingAnchor.constraint(equalTo: categoryContainerView.leadingAnchor, constant: 16),
            scheduleValueLabel.trailingAnchor.constraint(equalTo: categoryContainerView.trailingAnchor, constant: -40), // Оставляем место для стрелки
            
            // Кнопки
            cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.widthAnchor.constraint(equalToConstant: 166),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            
            createButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.widthAnchor.constraint(equalToConstant: 161),
            createButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupKeyboardHandling() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    

    
    private func updateCreateButtonState() {
        if isFormValid {
            createButton.backgroundColor = UIColor(named: "BlackDay")
            createButton.isEnabled = true
        } else {
            createButton.backgroundColor = UIColor(named: "Gray")
            createButton.isEnabled = false
        }
    }
    
    private func validateForm() {
        let hasName = !(nameTextField.text?.isEmpty ?? true)
        isFormValid = hasName
    }
    
    // MARK: - Actions
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    

    
    @objc private func keyboardWillShow(notification: NSNotification) {
        // Логика для скролла при появлении клавиатуры
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        // Логика для возврата к исходному состоянию
    }
    
    @objc private func categoryTapped() {
        // Показываем категорию только если введено название привычки
        if !(nameTextField.text?.isEmpty ?? true) {
            // Показываем "Важное" на той же позиции что и "Категория"
            categoryValueLabel.isHidden = false
            
            // Небольшая задержка для корректного отображения
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                // Анимация смещения слов
                UIView.animate(withDuration: 0.5, animations: {
                    self.categoryLabelTopConstraint?.constant = 20
                    self.categoryValueLabelTopConstraint?.constant = 45
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    @objc private func scheduleTapped() {
        // Показываем категорию только если введено название привычки
        if !(nameTextField.text?.isEmpty ?? true) {
            categoryValueLabel.isHidden = false
            // categoryLabel.isHidden = true // Убираем скрытие "Категория"
        }
        
        // Открываем модальное окно с расписанием
        let scheduleViewController = ScheduleViewController()
        scheduleViewController.modalPresentationStyle = .pageSheet
        
        // Передаем замыкание для получения выбранных дней
        scheduleViewController.onScheduleSelected = { [weak self] selectedDays in
            self?.updateScheduleValue(with: selectedDays)
        }
        
        present(scheduleViewController, animated: true)
    }
    

    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createButtonTapped() {
        // Логика создания привычки

        dismiss(animated: true)
    }
    
        private func updateScheduleValue(with selectedDays: Set<Int>) {
        // Если не выбран ни один день, ничего не показываем
        if selectedDays.isEmpty {
            scheduleValueLabel.isHidden = true
            return
        }
        
        // Показываем значение расписания
        scheduleValueLabel.isHidden = false
        
        // Формируем текст в зависимости от выбранных дней
        let daysOfWeek = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
        let selectedDayNames = selectedDays.sorted().map { daysOfWeek[$0] }
        
        if selectedDays.count == 7 {
            scheduleValueLabel.text = "Каждый день"
        } else {
            scheduleValueLabel.text = selectedDayNames.joined(separator: ", ")
        }
        
        // Небольшая задержка для корректного отображения
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Анимация смещения слов - центрируем в нижней половине
            UIView.animate(withDuration: 0.5, animations: {
                // "Расписание" смещается в центр нижней половины
                self.scheduleLabelTopConstraint?.constant = 95
                // Значение появляется под ним
                self.scheduleValueLabelTopConstraint?.constant = 120
                self.view.layoutIfNeeded()
            })
        }
    }
}



// MARK: - UITextFieldDelegate

extension CreateHabitViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if newText.count > maxCharacterCount {
            characterLimitLabel.isHidden = false
            return false
        } else {
            characterLimitLabel.isHidden = true
        }
        
        validateForm()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Дополнительная логика при начале редактирования
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        validateForm()
    }
} 