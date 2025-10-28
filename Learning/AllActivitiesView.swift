//
//  AllActivitiesView.swift
//  Learning
//
//  Created by Asma Abdullah Suliman on 26/04/1447 AH.
//

import SwiftUI

struct AllActivitiesView: View {
    @Environment(\.dismiss) var dismiss
    let learnedDays: Set<Int>
    let freezedDays: Set<Int>
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // شريط الحالة والعنوان
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                    }
                    
                    Text("All activities")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 50)
                
                // عرض جميع الأشهر
                ScrollView {
                    VStack(spacing: 30) {
                        ForEach([
                            "December 2025",
                            "November 2025",
                            "October 2025",
                            "September 2025",
                            "August 2025",
                            "July 2025",
                            "June 2025",
                            "May 2025",
                            "April 2025",
                            "March 2025",
                            "February 2025",
                            "January 2025"
                        ], id: \.self) { month in
                            MonthView(monthTitle: month, learnedDays: learnedDays, freezedDays: freezedDays)
                        }
                    }
                    .padding(.top, 20)
                }
            }
        }
    }
}

struct MonthView: View {
    let monthTitle: String
    let learnedDays: Set<Int>
    let freezedDays: Set<Int>
    
    var body: some View {
        VStack(spacing: 15) {
            // عنوان الشهر
            HStack {
                Text(monthTitle)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.horizontal, 20)
            
            // أيام الأسبوع
            HStack {
                ForEach(["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"], id: \.self) { day in
                    Text(day)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 20)
            
            // التواريخ (4 أسابيع كمثال)
            VStack(spacing: 8) {
                ForEach(0..<5, id: \.self) { week in
                    HStack(spacing: 8) {
                        ForEach(1...7, id: \.self) { dayIndex in
                            let day = week * 7 + dayIndex
                            if day <= 31 {
                                Text("\(day)")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white)
                                    .frame(width: 32, height: 32)
                                    .background(
                                        Circle()
                                            .fill(getDayColor(day: day))
                                    )
                                    .frame(maxWidth: .infinity)
                            } else {
                                Text("")
                                    .frame(width: 32, height: 32)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    private func getDayColor(day: Int) -> Color {
        if freezedDays.contains(day) {
            return Color(red: 0.3, green: 0.7, blue: 1.0)
        } else if learnedDays.contains(day) {
            return Color.orange
        } else {
            return Color.clear
        }
    }
}

#Preview {
    AllActivitiesView(learnedDays: [20, 21, 22], freezedDays: [24])
}

