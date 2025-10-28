//
//  ActivityViewModel.swift
//  Learning
//
//  Created by Asma Abdullah Suliman on 26/04/1447 AH.
//

import Foundation
import SwiftUI

// MARK: - Activity ViewModel

class ActivityViewModel: ObservableObject {
    @Published var learnedDays: Set<Int> = []
    @Published var freezedDays: Set<Int> = []
    @Published var selectedDay: Int?
    @Published var showMonthPicker: Bool = false
    @Published var showGoalCompleted: Bool = false
    @Published var showAllActivities: Bool = false
    @Published var currentWeekIndex: Int = 0
    @Published var currentMonth: String = "October"
    @Published var currentYear: Int = 2025
    
    let learningGoal: LearningGoal
    
    // أسابيع
    let defaultWeek = [20, 21, 22, 23, 24, 25, 26]
    let week1 = [13, 14, 15, 16, 17, 18, 19]
    let week2 = [27, 28, 29, 30, 31, 1, 2]
    
    init(learningGoal: LearningGoal) {
        self.learningGoal = learningGoal
    }
    
    // MARK: - Computed Properties
    
    var currentWeek: [Int] {
        switch currentWeekIndex {
        case -1: return week1
        case 0: return defaultWeek
        case 1: return week2
        default: return defaultWeek
        }
    }
    
    var daysLearned: Int {
        learnedDays.count
    }
    
    var daysFreezed: Int {
        freezedDays.count
    }
    
    var totalFreezes: Int {
        learningGoal.duration.totalFreezes
    }
    
    var isDayLearned: Bool {
        guard let selectedDay = selectedDay else { return false }
        return learnedDays.contains(selectedDay)
    }
    
    var isDayFreezed: Bool {
        guard let selectedDay = selectedDay else { return false }
        return freezedDays.contains(selectedDay)
    }
    
    // MARK: - Methods
    
    func logAsLearned() {
        guard let day = selectedDay else { return }
        learnedDays.insert(day)
        checkGoalCompletion()
    }
    
    func logAsFreezed() {
        guard let day = selectedDay,
              !isDayLearned,
              daysFreezed < totalFreezes else { return }
        freezedDays.insert(day)
    }
    
    func convertFreezedToLearned() {
        guard let day = selectedDay else { return }
        freezedDays.remove(day)
        learnedDays.insert(day)
        checkGoalCompletion()
    }
    
    func selectDay(_ day: Int) {
        selectedDay = day
    }
    
    func navigateWeek(direction: Int) {
        if direction < 0 && currentWeekIndex > 0 {
            currentWeekIndex -= 1
        } else if direction > 0 {
            currentWeekIndex += 1
        }
    }
    
    func resetGoal() {
        showGoalCompleted = false
        learnedDays.removeAll()
        freezedDays.removeAll()
        selectedDay = nil
    }
    
    func getDayColor(day: Int) -> Color {
        if freezedDays.contains(day) {
            return Color(red: 0.3, green: 0.7, blue: 1.0)
        } else if learnedDays.contains(day) {
            return Color.orange
        } else if selectedDay == day {
            return Color.orange.opacity(0.5)
        } else {
            return Color.clear
        }
    }
    
    private func checkGoalCompletion() {
        if daysLearned >= learningGoal.duration.totalDays {
            showGoalCompleted = true
        }
    }
}

