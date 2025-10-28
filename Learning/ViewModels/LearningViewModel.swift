//
//  LearningViewModel.swift
//  Learning
//
//  Created by Asma Abdullah Suliman on 26/04/1447 AH.
//

import Foundation
import SwiftUI

// MARK: - Learning Setup ViewModel

class LearningViewModel: ObservableObject {
    @Published var learningTopic: String = "Swift"
    @Published var selectedDuration: LearningGoal.Duration = .week
    @Published var showActivity: Bool = false
    
    func startLearning() {
        showActivity = true
    }
    
    func createLearningGoal() -> LearningGoal {
        return LearningGoal(
            topic: learningTopic,
            duration: selectedDuration,
            startDate: Date()
        )
    }
}

