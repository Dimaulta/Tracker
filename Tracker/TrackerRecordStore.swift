//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Ульта on 26.07.2025.
//

import Foundation
import CoreData

protocol TrackerRecordStoreProtocol {
    func createRecord(trackerId: UUID, date: Date) -> TrackerRecord
    func fetchRecords(for trackerId: UUID?) -> [TrackerRecord]
    func deleteRecord(_ record: TrackerRecord)
    func isTrackerCompleted(trackerId: UUID, date: Date) -> Bool
    func toggleTrackerCompletion(trackerId: UUID, date: Date)
    func getCompletedCount(for trackerId: UUID) -> Int
}

class TrackerRecordStore: TrackerRecordStoreProtocol {
    private let coreDataManager = CoreDataManager.shared
    
    func createRecord(trackerId: UUID, date: Date) -> TrackerRecord {
        let coreDataRecord = coreDataManager.createRecord(trackerId: trackerId, date: date)
        return coreDataRecord.toTrackerRecord()
    }
    
    func fetchRecords(for trackerId: UUID?) -> [TrackerRecord] {
        let coreDataRecords = coreDataManager.fetchRecords(for: trackerId)
        return coreDataRecords.map { $0.toTrackerRecord() }
    }
    
    func deleteRecord(_ record: TrackerRecord) {
        let request = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "trackerId == %@ AND date == %@", 
                                      record.trackerId as CVarArg, 
                                      record.date as CVarArg)
        
        do {
            let coreDataRecords = try coreDataManager.context.fetch(request)
            if let coreDataRecord = coreDataRecords.first {
                coreDataManager.deleteRecord(coreDataRecord)
            }
        } catch {
            print("Error finding record to delete: \(error)")
        }
    }
    
    func isTrackerCompleted(trackerId: UUID, date: Date) -> Bool {
        return coreDataManager.isTrackerCompleted(trackerId: trackerId, date: date)
    }
    
    func toggleTrackerCompletion(trackerId: UUID, date: Date) {
        coreDataManager.toggleTrackerCompletion(trackerId: trackerId, date: date)
    }
    
    func getCompletedCount(for trackerId: UUID) -> Int {
        return coreDataManager.fetchRecords(for: trackerId).count
    }
}
