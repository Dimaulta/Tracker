//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Ульта on 26.07.2025.
//

import UIKit

class TrackersViewController: UIViewController {
    
    // MARK: - UI Elements
    private let titleLabel = UILabel()
    private let addButton = UIButton(type: .system)
    private let searchContainerView = UIView()
    private let searchTextField = UITextField()
    private let searchIconView = UIImageView()
    private let datePicker = UIDatePicker()
    private let emptyStateImageView = UIImageView()
    private let emptyStateLabel = UILabel()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: - Data
    private var habits: [Habit] = []
    var selectedDate: Date = Date()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadHabits()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "WhiteDay")
        setupNavigationBar()
        setupAddButton()
        setupTitle()
        setupSearchBar()
        setupDatePicker()
        setupCollectionView()
        setupEmptyState()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupTitle() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Трекеры"
        titleLabel.font = UIFont(name: "SFPro-Bold", size: 34) ?? UIFont.boldSystemFont(ofSize: 34)
        titleLabel.textColor = UIColor(named: "BlackDay")
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.widthAnchor.constraint(equalToConstant: 254),
            titleLabel.heightAnchor.constraint(equalToConstant: 41)
        ])
    }
    
    private func setupAddButton() {
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setImage(UIImage(named: "Add tracker"), for: .normal)
        addButton.tintColor = UIColor.black
        addButton.backgroundColor = UIColor.clear
        addButton.alpha = 1.0
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        view.addSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 45),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            addButton.widthAnchor.constraint(equalToConstant: 42),
            addButton.heightAnchor.constraint(equalToConstant: 42)
        ])
    }
    
    private func setupDatePicker() {
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.date = selectedDate
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        view.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: view.topAnchor, constant: 49),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            datePicker.widthAnchor.constraint(equalToConstant: 120),
            datePicker.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    private func setupSearchBar() {
        // Настройка контейнера
        searchContainerView.translatesAutoresizingMaskIntoConstraints = false
        searchContainerView.backgroundColor = UIColor(named: "LightGray")
        searchContainerView.layer.cornerRadius = 10
        searchContainerView.clipsToBounds = true
        view.addSubview(searchContainerView)
        
        // Настройка иконки лупы
        searchIconView.translatesAutoresizingMaskIntoConstraints = false
        searchIconView.image = UIImage(systemName: "magnifyingglass")
        searchIconView.tintColor = UIColor(named: "Gray")
        searchContainerView.addSubview(searchIconView)
        
        // Настройка текстового поля
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.placeholder = "Поиск"
        searchTextField.backgroundColor = .clear
        searchTextField.borderStyle = .none
        searchTextField.font = UIFont(name: "SFPro-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .regular)
        searchTextField.textColor = UIColor(named: "Gray")
        searchContainerView.addSubview(searchTextField)
        
        NSLayoutConstraint.activate([
            // Контейнер
            searchContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 136),
            searchContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchContainerView.heightAnchor.constraint(equalToConstant: 36),
            
            // Иконка лупы
            searchIconView.topAnchor.constraint(equalTo: searchContainerView.topAnchor, constant: 10),
            searchIconView.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor, constant: 8),
            searchIconView.widthAnchor.constraint(equalToConstant: 15.63),
            searchIconView.heightAnchor.constraint(equalToConstant: 15.78),
            
            // Текстовое поле
            searchTextField.topAnchor.constraint(equalTo: searchContainerView.topAnchor, constant: 7),
            searchTextField.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor, constant: 30),
            searchTextField.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor, constant: -8),
            searchTextField.bottomAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: -7)
        ])
    }
    
    private func setupEmptyState() {
        emptyStateImageView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateImageView.image = UIImage(named: "Dizzy")
        emptyStateImageView.contentMode = .scaleAspectFit
        emptyStateImageView.alpha = 1.0
        view.addSubview(emptyStateImageView)
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyStateLabel.text = "Что будем отслеживать?"
        emptyStateLabel.font = UIFont.systemFont(ofSize: 12)
        emptyStateLabel.textColor = UIColor(named: "BlackDay")
        emptyStateLabel.textAlignment = .center
        view.addSubview(emptyStateLabel)
        NSLayoutConstraint.activate([
            emptyStateImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateImageView.widthAnchor.constraint(equalToConstant: 80),
            emptyStateImageView.heightAnchor.constraint(equalToConstant: 80),
            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateImageView.bottomAnchor, constant: 8),
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 16),
            emptyStateLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func addButtonTapped() {
        let createHabitViewController = CreateHabitViewController()
        createHabitViewController.delegate = self
        createHabitViewController.modalPresentationStyle = .pageSheet
        present(createHabitViewController, animated: true)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        selectedDate = sender.date
        updateUI()
    }
    
    private func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: HabitCollectionViewCell.identifier)
        
        // Настройка layout
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumInteritemSpacing = 8
            layout.minimumLineSpacing = 8
            layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Data Management
    private func loadHabits() {
        if let data = UserDefaults.standard.data(forKey: "habits"),
           let savedHabits = try? JSONDecoder().decode([Habit].self, from: data) {
            habits = savedHabits
            updateUI()
        }
    }
    
    private func saveHabits() {
        if let data = try? JSONEncoder().encode(habits) {
            UserDefaults.standard.set(data, forKey: "habits")
        }
    }
    
    private func addHabit(_ habit: Habit) {
        habits.append(habit)
        saveHabits()
        updateUI()
    }
    
    func updateUI() {
        collectionView.reloadData()
        
        // Показываем/скрываем пустое состояние
        let isEmpty = habits.isEmpty
        emptyStateImageView.isHidden = !isEmpty
        emptyStateLabel.isHidden = !isEmpty
        collectionView.isHidden = isEmpty
    }
    
    // MARK: - Habit Management
    private func toggleHabitCompletion(for habit: Habit) {
        guard let index = habits.firstIndex(where: { $0.id == habit.id }) else { return }
        
        var updatedHabit = habit
        
        if habit.isCompleted(for: selectedDate) {
            // Убираем отметку
            updatedHabit.completedDates.removeAll { date in
                Calendar.current.isDate(date, inSameDayAs: selectedDate)
            }
        } else {
            // Добавляем отметку только если не будущая дата
            if habit.canBeCompleted(for: selectedDate) {
                updatedHabit.completedDates.append(selectedDate)
            }
        }
        
        habits[index] = updatedHabit
        saveHabits()
        updateUI()
    }
}

// MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return habits.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HabitCollectionViewCell.identifier, for: indexPath) as! HabitCollectionViewCell
        let habit = habits[indexPath.item]
        cell.configure(with: habit, selectedDate: selectedDate)
        cell.onCompletionToggled = { [weak self] habit in
            self?.toggleHabitCompletion(for: habit)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 48) / 2 // 2 колонки с отступами
        return CGSize(width: width, height: 160) // Увеличиваем высоту для кнопки
    }
}

// MARK: - CreateHabitViewControllerDelegate
extension TrackersViewController: CreateHabitViewControllerDelegate {
    func didCreateHabit(_ habit: Habit) {
        addHabit(habit)
    }
} 