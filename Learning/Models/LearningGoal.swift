//
//  LearningGoal.swift
//  Learning
//
//  Created by Asma Abdullah Suliman on 26/04/1447 AH.
//

import Foundation

// MARK: - Models

struct LearningGoal: Identifiable {
    let id = UUID()
    var topic: String
    var duration: Duration
    var startDate: Date
    
    enum Duration: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
        
        var totalDays: Int {
            switch self {
            case .week: return 7
            case .month: return 30
            case .year: return 365
            }
        }
        
        var totalFreezes: Int {
            switch self {
            case .week: return 2
            case .month: return 8
            case .year: return 96
            }
        }
    }
}

struct DayActivity: Identifiable {
    let id = UUID()
    let day: Int
    var status: ActivityStatus
    
    enum ActivityStatus {
        case notStarted
        case learned
        case freezed
    }
}

