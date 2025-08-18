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
    func startObservingChanges(onUpdate: @escaping ([TrackerCategory]) -> Void)
    func stopObservingChanges()
}

class TrackerCategoryStore: NSObject, TrackerCategoryStoreProtocol {
    private let coreDataManager = CoreDataManager.shared
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>?
    private var onUpdateCallback: (([TrackerCategory]) -> Void)?
    
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
    
    func startObservingChanges(onUpdate: @escaping ([TrackerCategory]) -> Void) {
        self.onUpdateCallback = onUpdate
        
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: coreDataManager.context,
            sectionNameKeyPath: nil,
            cacheName: "TrackerCategoryStore"
        )
        
        fetchedResultsController?.delegate = self
        
        do {
            try fetchedResultsController?.performFetch()
            notifyUpdate()
        } catch {
            print("Error performing fetch: \(error)")
        }
    }
    
    func stopObservingChanges() {
        fetchedResultsController?.delegate = nil
        fetchedResultsController = nil
        onUpdateCallback = nil
    }
    
    private func notifyUpdate() {
        guard let fetchedObjects = fetchedResultsController?.fetchedObjects else { return }
        let categories = fetchedObjects.map { $0.toTrackerCategory() }
        onUpdateCallback?(categories)
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        notifyUpdate()
    }
}
