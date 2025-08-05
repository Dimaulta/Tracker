//
//  Habit.swift
//  Tracker
//
//  Created by Ульта on 26.07.2025.
//
 
import Foundation

struct Habit: Codable {
    let id: UUID
    let name: String
    let category: String
    let schedule: [Int] // Индексы дней недели (0-6)
    let emoji: String
    let color: String // Название цвета из ассетов
    var completedDates: [Date] // Даты, когда привычка была выполнена
    
    init(name: String, category: String, schedule: [Int], emoji: String, color: String) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.schedule = schedule
        self.emoji = emoji
        self.color = color
        self.completedDates = []
    }
    
    // Проверяет, выполнена ли привычка в указанную дату
    func isCompleted(for date: Date) -> Bool {
        let calendar = Calendar.current
        return completedDates.contains { completedDate in
            calendar.isDate(completedDate, inSameDayAs: date)
        }
    }
    
    // Возвращает количество выполненных дней
    var completedCount: Int {
        return completedDates.count
    }
    
    // Проверяет, можно ли выполнить привычку в указанную дату (не будущая дата)
    func canBeCompleted(for date: Date) -> Bool {
        let calendar = Calendar.current
        let today = Date()
        return calendar.compare(date, to: today, toGranularity: .day) != .orderedDescending
    }
} 