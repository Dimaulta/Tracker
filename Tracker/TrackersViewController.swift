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
    private let categoryHeaderLabel = UILabel()
    
    // MARK: - Data
    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private var completedTrackerIds: Set<UUID> = []
    var currentDate: Date = Date()
    
    // MARK: - Computed Properties
    private var visibleCategories: [TrackerCategory] {
        print("🔍 Debug: currentDate = \(currentDate)")
        print("🔍 Debug: Всего категорий = \(categories.count)")
        
        let result = categories.map { category in
            print("🔍 Debug: Категория '\(category.title)' с \(category.trackers.count) трекерами")
            let filteredTrackers = category.trackers.filter { tracker in
                let isScheduled = tracker.isScheduled(for: currentDate)
                print("  Трекер '\(tracker.name)' запланирован на сегодня: \(isScheduled)")
                return isScheduled
            }
            print("  После фильтрации осталось \(filteredTrackers.count) трекеров")
            return TrackerCategory(title: category.title, trackers: filteredTrackers)
        }.filter { !$0.trackers.isEmpty }
        
        print("🔍 Debug: Итого видимых категорий = \(result.count)")
        return result
    }
    
    private var visibleTrackers: [Tracker] {
        var allTrackers: [Tracker] = []
        for category in categories {
            allTrackers.append(contentsOf: category.trackers)
        }
        return allTrackers.filter { $0.isScheduled(for: currentDate) }
    }
    
    private func getCompletedCount(for tracker: Tracker) -> Int {
        return completedTrackers.filter { $0.trackerId == tracker.id }.count
    }
    
    private func isTrackerCompleted(for tracker: Tracker) -> Bool {
        return completedTrackers.contains { $0.trackerId == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: currentDate) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadData()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "WhiteDay")
        setupNavigationBar()
        setupAddButton()
        setupTitle()
        setupSearchBar()
        setupDatePicker()
        setupCategoryHeader()
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
        datePicker.date = currentDate
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
    
    private func setupCategoryHeader() {
        categoryHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryHeaderLabel.text = "Важное"
        categoryHeaderLabel.font = UIFont(name: "SFPro-Bold", size: 19) ?? UIFont.boldSystemFont(ofSize: 19)
        categoryHeaderLabel.textColor = UIColor(named: "BlackDay")
        categoryHeaderLabel.isHidden = true
        view.addSubview(categoryHeaderLabel)
        
        print("🔍 Debug: Настроен заголовок категории '\(categoryHeaderLabel.text ?? "")'")
        
        NSLayoutConstraint.activate([
            categoryHeaderLabel.topAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: 34),
            categoryHeaderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            categoryHeaderLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
    
    private func setupSearchBar() {
        searchContainerView.translatesAutoresizingMaskIntoConstraints = false
        searchContainerView.backgroundColor = UIColor(named: "LightGray")
        searchContainerView.layer.cornerRadius = 10
        searchContainerView.clipsToBounds = true
        view.addSubview(searchContainerView)
        
        searchIconView.translatesAutoresizingMaskIntoConstraints = false
        searchIconView.image = UIImage(systemName: "magnifyingglass")
        searchIconView.tintColor = UIColor(named: "Gray")
        searchContainerView.addSubview(searchIconView)
        
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.placeholder = "Поиск"
        searchTextField.backgroundColor = .clear
        searchTextField.borderStyle = .none
        searchTextField.font = UIFont(name: "SFPro-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .regular)
        searchTextField.textColor = UIColor(named: "Gray")
        searchContainerView.addSubview(searchTextField)
        
        NSLayoutConstraint.activate([
            searchContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 136),
            searchContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchContainerView.heightAnchor.constraint(equalToConstant: 36),
            
            searchIconView.topAnchor.constraint(equalTo: searchContainerView.topAnchor, constant: 10),
            searchIconView.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor, constant: 8),
            searchIconView.widthAnchor.constraint(equalToConstant: 15.63),
            searchIconView.heightAnchor.constraint(equalToConstant: 15.78),
            
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
        currentDate = sender.date
        updateUI()
    }
    
    private func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: TrackerCollectionViewCell.identifier)
        
        // Создаём новый layout с правильными параметрами
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        collectionView.setCollectionViewLayout(layout, animated: false)
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: categoryHeaderLabel.bottomAnchor, constant: 6),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Data Management
    private func loadData() {
        if let data = UserDefaults.standard.data(forKey: "categories"),
           let savedCategories = try? JSONDecoder().decode([TrackerCategory].self, from: data) {
            categories = savedCategories
            print("🔍 Debug: Загружено \(categories.count) категорий:")
            for (index, category) in categories.enumerated() {
                print("  Категория \(index): '\(category.title)' с \(category.trackers.count) трекерами")
            }
        }
        if let data = UserDefaults.standard.data(forKey: "completedTrackers"),
           let savedCompletedTrackers = try? JSONDecoder().decode([TrackerRecord].self, from: data) {
            completedTrackers = savedCompletedTrackers
            completedTrackerIds = Set(completedTrackers.map(\.trackerId))
        }
        updateUI()
    }
    
    private func saveData() {
        if let data = try? JSONEncoder().encode(categories) {
            UserDefaults.standard.set(data, forKey: "categories")
        }
        if let data = try? JSONEncoder().encode(completedTrackers) {
            UserDefaults.standard.set(data, forKey: "completedTrackers")
        }
    }
    
    private func addTracker(_ tracker: Tracker) {
        // Ищем существующую категорию "Важное"
        if let existingCategoryIndex = categories.firstIndex(where: { $0.title == "Важное" }) {
            // Создаём новую категорию с обновлённым списком трекеров
            let existingCategory = categories[existingCategoryIndex]
            let updatedCategory = TrackerCategory(title: existingCategory.title, trackers: existingCategory.trackers + [tracker])
            categories[existingCategoryIndex] = updatedCategory
        } else {
            // Создаём новую категорию только если её нет
            let category = TrackerCategory(title: "Важное", trackers: [tracker])
            categories.append(category)
        }
        saveData()
        updateUI()
    }
    
    func updateUI() {
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
        
        let isEmpty = visibleTrackers.isEmpty
        print("🔍 Debug: isEmpty = \(isEmpty), visibleTrackers.count = \(visibleTrackers.count)")
        
        emptyStateImageView.isHidden = !isEmpty
        emptyStateLabel.isHidden = !isEmpty
        collectionView.isHidden = isEmpty
        categoryHeaderLabel.isHidden = isEmpty
        
        print("🔍 Debug: categoryHeaderLabel.isHidden = \(categoryHeaderLabel.isHidden)")
    }
    
    // MARK: - Tracker Management
    private func toggleTrackerCompletion(for tracker: Tracker) {
        print("🔍 Debug: toggleTrackerCompletion вызван для трекера '\(tracker.name)'")
        
        let calendar = Calendar.current
        let today = Date()
        let canBeCompleted = calendar.compare(currentDate, to: today, toGranularity: .day) != .orderedDescending
        
        print("🔍 Debug: canBeCompleted = \(canBeCompleted)")
        
        if !canBeCompleted {
            print("🔍 Debug: Трекер не может быть завершён")
            return
        }
        
        let record = TrackerRecord(trackerId: tracker.id, date: currentDate)
        
        if completedTrackerIds.contains(tracker.id) {
            print("🔍 Debug: Удаляю завершение трекера")
            completedTrackers.removeAll { $0.trackerId == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: currentDate) }
            completedTrackerIds.remove(tracker.id)
        } else {
            print("🔍 Debug: Добавляю завершение трекера")
            completedTrackers.append(record)
            completedTrackerIds.insert(tracker.id)
        }
        
        saveData()
        updateUI()
    }
}

// MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleTrackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.identifier, for: indexPath) as! TrackerCollectionViewCell
        let tracker = visibleTrackers[indexPath.item]
        let completedCount = getCompletedCount(for: tracker)
        let isCompleted = isTrackerCompleted(for: tracker)
        
        // Сначала устанавливаем callback
        cell.onCompletionToggled = { [weak self] tracker in
            self?.toggleTrackerCompletion(for: tracker)
        }
        
        // Потом настраиваем ячейку
        cell.configure(with: tracker, selectedDate: currentDate, isCompleted: isCompleted, completedCount: completedCount)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 167, height: 90)
    }
}

// MARK: - CreateHabitViewControllerDelegate
extension TrackersViewController: CreateHabitViewControllerDelegate {
    func didCreateTracker(_ tracker: Tracker) {
        addTracker(tracker)
    }
} 