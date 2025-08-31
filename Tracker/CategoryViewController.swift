//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Ульта on 30.08.2025.
//

import UIKit

protocol CategoryViewControllerDelegate: AnyObject {
    func didSelectCategory(_ category: TrackerCategory)
}

final class CategoryViewController: UIViewController {
    
    // MARK: - UI Elements
    private let titleLabel = UILabel()
    private let tableView = UITableView()
    private let addCategoryButton = UIButton(type: .system)
    private let emptyStateImageView = UIImageView()
    private let emptyStateLabel = UILabel()
    
    // MARK: - Properties
    private var viewModel: CategoryViewModelProtocol
    weak var delegate: CategoryViewControllerDelegate?
    
    // MARK: - Initialization
    init(viewModel: CategoryViewModelProtocol = CategoryViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.loadCategories()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = UIColor.white
        
        setupTitle()
        setupTableView()
        setupAddButton()
        setupEmptyState()
    }
    
    private func setupTitle() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Категория"
        titleLabel.font = UIFont(name: "SFPro-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = UIColor(named: "BlackDay")
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        view.addSubview(tableView)
    }
    
    private func setupAddButton() {
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        addCategoryButton.setTitle("Добавить категорию", for: .normal)
        addCategoryButton.setTitleColor(UIColor.white, for: .normal)
        addCategoryButton.titleLabel?.font = UIFont(name: "SFPro-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium)
        addCategoryButton.backgroundColor = UIColor(named: "BlackDay")
        addCategoryButton.layer.cornerRadius = 16
        addCategoryButton.addTarget(self, action: #selector(addCategoryButtonTapped), for: .touchUpInside)
        view.addSubview(addCategoryButton)
        
        // Устанавливаем констрейнты для tableView и addCategoryButton вместе
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -20),
            
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupEmptyState() {
        emptyStateImageView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateImageView.image = UIImage(named: "Dizzy")
        emptyStateImageView.contentMode = .scaleAspectFit
        emptyStateImageView.isHidden = true
        view.addSubview(emptyStateImageView)
        
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyStateLabel.text = "Привычки и события можно\nобъединить по смыслу"
        emptyStateLabel.font = UIFont(name: "SFPro-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12)
        emptyStateLabel.textColor = UIColor(named: "BlackDay")
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.numberOfLines = 0
        emptyStateLabel.isHidden = true
        view.addSubview(emptyStateLabel)
        
        NSLayoutConstraint.activate([
            emptyStateImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            emptyStateImageView.widthAnchor.constraint(equalToConstant: 80),
            emptyStateImageView.heightAnchor.constraint(equalToConstant: 80),
            
            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateImageView.bottomAnchor, constant: 8),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupBindings() {
        viewModel.onCategoriesUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
        
        viewModel.onCategorySelected = { [weak self] category in
            print("CategoryViewController: onCategorySelected callback triggered with category: \(category.title)")
            // НЕ вызываем делегата автоматически - только при ручном выборе
            // НЕ закрываем окно - пользователь должен сам выбрать категорию
        }
        
        viewModel.onCategoryCreated = { [weak self] category in
            print("CategoryViewController: onCategoryCreated callback triggered with category: \(category.title)")
            // При создании новой категории автоматически выбираем её и обновляем UI
            DispatchQueue.main.async {
                print("CategoryViewController: Selecting category: \(category.title)")
                self?.viewModel.selectCategory(category)
                // НЕ закрываем CategoryViewController - показываем список с новой категорией
                print("CategoryViewController: Category created, showing updated list")
            }
        }
    }
    
    // MARK: - UI Updates
    private func updateUI() {
        let hasCategories = !viewModel.categories.isEmpty
        tableView.isHidden = !hasCategories
        emptyStateImageView.isHidden = hasCategories
        emptyStateLabel.isHidden = hasCategories
        
        tableView.reloadData()
    }
    
    // MARK: - Actions
    @objc private func addCategoryButtonTapped() {
        let createCategoryVC = CreateCategoryViewController(viewModel: viewModel)
        createCategoryVC.modalPresentationStyle = .pageSheet
        present(createCategoryVC, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as! CategoryTableViewCell
        
        let category = viewModel.categories[indexPath.row]
        let isSelected = viewModel.selectedCategory?.title == category.title
        cell.configure(with: category, isSelected: isSelected)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = viewModel.categories[indexPath.row]
        print("CategoryViewController: User manually selected category: \(category.title)")
        // Вызываем делегата и закрываем окно при ручном выборе категории
        delegate?.didSelectCategory(category)
        dismiss(animated: true)
    }
}
