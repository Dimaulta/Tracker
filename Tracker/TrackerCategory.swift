//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Ульта on 26.07.2025.
//

import Foundation

struct TrackerCategory: Codable {
    let title: String
    let trackers: [Tracker]
    
    init(title: String, trackers: [Tracker]) {
        self.title = title
        self.trackers = trackers
    }
} 