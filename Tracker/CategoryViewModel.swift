//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Ульта on 30.08.2025.
//

import Foundation

protocol CategoryViewModelProtocol {
    var categories: [TrackerCategory] { get }
    var selectedCategory: TrackerCategory? { get }
    var onCategoriesUpdate: (() -> Void)? { get set }
    var onCategorySelected: ((TrackerCategory) -> Void)? { get set }
    var onCategoryCreated: ((TrackerCategory) -> Void)? { get set }
    
    func loadCategories()
    func selectCategory(_ category: TrackerCategory)
    func createCategory(title: String)
    func updateCategoryTitle(_ category: TrackerCategory, newTitle: String)
    func deleteCategory(_ category: TrackerCategory)
}

final class CategoryViewModel: CategoryViewModelProtocol {
    
    // MARK: - Properties
    private let categoryStore: TrackerCategoryStoreProtocol
    private(set) var categories: [TrackerCategory] = []
    private(set) var selectedCategory: TrackerCategory?
    
    // MARK: - Bindings
    var onCategoriesUpdate: (() -> Void)?
    var onCategorySelected: ((TrackerCategory) -> Void)?
    var onCategoryCreated: ((TrackerCategory) -> Void)?
    
    // MARK: - Initialization
    init(categoryStore: TrackerCategoryStoreProtocol = TrackerCategoryStore()) {
        self.categoryStore = categoryStore
        setupObservers()
    }
    
    deinit {
        categoryStore.stopObservingChanges()
    }
    
    // MARK: - Private Methods
    private func setupObservers() {
        categoryStore.startObservingChanges { [weak self] categories in
            self?.categories = categories
            self?.onCategoriesUpdate?()
        }
    }
    
    // MARK: - Public Methods
    func loadCategories() {
        categories = categoryStore.fetchCategories()
        onCategoriesUpdate?()
    }
    
    func selectCategory(_ category: TrackerCategory) {
        print("CategoryViewModel: selectCategory called with category: \(category.title)")
        selectedCategory = category
        print("CategoryViewModel: Calling onCategorySelected callback")
        onCategorySelected?(category)
    }
    
    func createCategory(title: String) {
        print("CategoryViewModel: createCategory called with title: \(title)")
        let newCategory = categoryStore.createCategory(title: title)
        print("CategoryViewModel: Created category: \(newCategory.title)")
        // Уведомляем о создании категории
        print("CategoryViewModel: Calling onCategoryCreated callback")
        onCategoryCreated?(newCategory)
    }
    
    func updateCategoryTitle(_ category: TrackerCategory, newTitle: String) {
        categoryStore.updateCategoryTitle(category, newTitle: newTitle)
        // Данные обновятся автоматически через NSFetchedResultsController
    }
    
    func deleteCategory(_ category: TrackerCategory) {
        categoryStore.deleteCategory(category)
        // Данные обновятся автоматически через NSFetchedResultsController
    }
}
