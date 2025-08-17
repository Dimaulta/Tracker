//
//  TrackerStore.swift
//  Tracker
//
//  Created by Ульта on 26.07.2025.
//

import Foundation
import CoreData

protocol TrackerStoreProtocol {
    func createTracker(name: String, color: String, emoji: String, schedule: [Int], categoryTitle: String) -> Tracker
    func fetchTrackers() -> [Tracker]
    func deleteTracker(_ tracker: Tracker)
    func getOrCreateCategory(title: String) -> TrackerCategory
    func fetchCategories() -> [TrackerCategory]
}

class TrackerStore: TrackerStoreProtocol {
    private let coreDataManager = CoreDataManager.shared
    
    func createTracker(name: String, color: String, emoji: String, schedule: [Int], categoryTitle: String) -> Tracker {
        let coreDataTracker = coreDataManager.createTracker(
            name: name,
            color: color,
            emoji: emoji,
            schedule: schedule,
            categoryTitle: categoryTitle
        )
        return coreDataTracker.toTracker()
    }
    
    func fetchTrackers() -> [Tracker] {
        let coreDataTrackers = coreDataManager.fetchTrackers()
        return coreDataTrackers.map { $0.toTracker() }
    }
    
    func deleteTracker(_ tracker: Tracker) {
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        
        do {
            let coreDataTrackers = try coreDataManager.context.fetch(request)
            if let coreDataTracker = coreDataTrackers.first {
                coreDataManager.deleteTracker(coreDataTracker)
            }
        } catch {
            print("Error finding tracker to delete: \(error)")
        }
    }
    
    func getOrCreateCategory(title: String) -> TrackerCategory {
        let coreDataCategory = coreDataManager.getOrCreateCategory(title: title)
        return coreDataCategory.toTrackerCategory()
    }
    
    func fetchCategories() -> [TrackerCategory] {
        let coreDataCategories = coreDataManager.fetchCategories()
        return coreDataCategories.map { $0.toTrackerCategory() }
    }
}
