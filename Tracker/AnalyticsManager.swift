//
//  AnalyticsManager.swift
//  Tracker
//
//  Created by Ульта on 13.09.2025.
//

import Foundation
import YandexMobileMetrica

final class AnalyticsManager {
    static let shared = AnalyticsManager()
    
    private init() {}
    
    // MARK: - Tracker Events
    func trackTrackerCreated(name: String, category: String, schedule: [Int]) {
        let parameters: [String: Any] = [
            "tracker_name": name,
            "category": category,
            "schedule_days": schedule.count,
            "is_daily": schedule.count == 7
        ]
        
        YMMYandexMetrica.reportEvent("tracker_created", parameters: parameters)
    }
    
    func trackTrackerCompleted(trackerId: UUID, trackerName: String) {
        let parameters: [String: Any] = [
            "tracker_id": trackerId.uuidString,
            "tracker_name": trackerName
        ]
        
        YMMYandexMetrica.reportEvent("tracker_completed", parameters: parameters)
    }
    
    func trackTrackerUncompleted(trackerId: UUID, trackerName: String) {
        let parameters: [String: Any] = [
            "tracker_id": trackerId.uuidString,
            "tracker_name": trackerName
        ]
        
        YMMYandexMetrica.reportEvent("tracker_uncompleted", parameters: parameters)
    }
    
    func trackTrackerEdited(trackerId: UUID, trackerName: String) {
        let parameters: [String: Any] = [
            "tracker_id": trackerId.uuidString,
            "tracker_name": trackerName
        ]
        
        YMMYandexMetrica.reportEvent("tracker_edited", parameters: parameters)
    }
    
    func trackTrackerDeleted(trackerId: UUID, trackerName: String) {
        let parameters: [String: Any] = [
            "tracker_id": trackerId.uuidString,
            "tracker_name": trackerName
        ]
        
        YMMYandexMetrica.reportEvent("tracker_deleted", parameters: parameters)
    }
    
    // MARK: - Category Events
    func trackCategoryCreated(categoryName: String) {
        let parameters: [String: Any] = [
            "category_name": categoryName
        ]
        
        YMMYandexMetrica.reportEvent("category_created", parameters: parameters)
    }
    
    func trackCategoryEdited(oldName: String, newName: String) {
        let parameters: [String: Any] = [
            "old_category_name": oldName,
            "new_category_name": newName
        ]
        
        YMMYandexMetrica.reportEvent("category_edited", parameters: parameters)
    }
    
    func trackCategoryDeleted(categoryName: String) {
        let parameters: [String: Any] = [
            "category_name": categoryName
        ]
        
        YMMYandexMetrica.reportEvent("category_deleted", parameters: parameters)
    }
    
    // MARK: - Screen Events
    func trackScreenView(screenName: String) {
        let parameters: [String: Any] = [
            "screen_name": screenName
        ]
        
        YMMYandexMetrica.reportEvent("screen_view", parameters: parameters)
    }
    
    func trackStatisticsViewed() {
        YMMYandexMetrica.reportEvent("statistics_viewed")
    }
    
    func trackFiltersUsed(filterType: String) {
        let parameters: [String: Any] = [
            "filter_type": filterType
        ]
        
        YMMYandexMetrica.reportEvent("filters_used", parameters: parameters)
    }
    
    // MARK: - User Actions
    func trackButtonTapped(buttonName: String, screenName: String) {
        let parameters: [String: Any] = [
            "button_name": buttonName,
            "screen_name": screenName
        ]
        
        YMMYandexMetrica.reportEvent("button_tapped", parameters: parameters)
    }
    
    func trackSearchPerformed(query: String, resultsCount: Int) {
        let parameters: [String: Any] = [
            "search_query": query,
            "results_count": resultsCount
        ]
        
        YMMYandexMetrica.reportEvent("search_performed", parameters: parameters)
    }
}
