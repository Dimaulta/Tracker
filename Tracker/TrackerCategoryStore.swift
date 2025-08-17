//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Ульта on 26.07.2025.
//

import Foundation
import CoreData

protocol TrackerCategoryStoreProtocol {
    func createCategory(title: String) -> TrackerCategory
    func fetchCategories() -> [TrackerCategory]
    func deleteCategory(_ category: TrackerCategory)
    func getCategory(by title: String) -> TrackerCategory?
}

class TrackerCategoryStore: TrackerCategoryStoreProtocol {
    private let coreDataManager = CoreDataManager.shared
    
    func createCategory(title: String) -> TrackerCategory {
        let coreDataCategory = coreDataManager.getOrCreateCategory(title: title)
        return coreDataCategory.toTrackerCategory()
    }
    
    func fetchCategories() -> [TrackerCategory] {
        let coreDataCategories = coreDataManager.fetchCategories()
        return coreDataCategories.map { $0.toTrackerCategory() }
    }
    
    func deleteCategory(_ category: TrackerCategory) {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", category.title)
        
        do {
            let coreDataCategories = try coreDataManager.context.fetch(request)
            if let coreDataCategory = coreDataCategories.first {
                coreDataManager.context.delete(coreDataCategory)
                coreDataManager.saveContext()
            }
        } catch {
            print("Error finding category to delete: \(error)")
        }
    }
    
    func getCategory(by title: String) -> TrackerCategory? {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)
        
        do {
            let coreDataCategories = try coreDataManager.context.fetch(request)
            return coreDataCategories.first?.toTrackerCategory()
        } catch {
            print("Error finding category: \(error)")
            return nil
        }
    }
}
