import Foundation

protocol CreateHabitViewControllerDelegate: AnyObject {
    func didCreateHabit(_ habit: Habit)
} 