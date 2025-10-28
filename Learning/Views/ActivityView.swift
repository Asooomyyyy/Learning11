//
//  ActivityView.swift
//  Learning
//
//  Created by Asma Abdullah Suliman on 26/04/1447 AH.
//

import SwiftUI

struct ActivityView: View {
    @Binding var isPresented: Bool
    @StateObject private var viewModel: ActivityViewModel
    
    init(isPresented: Binding<Bool>, learningGoal: LearningGoal) {
        self._isPresented = isPresented
        self._viewModel = StateObject(wrappedValue: ActivityViewModel(learningGoal: learningGoal))
    }
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                StatusBarView()
                
                HeaderView(showAllActivities: $viewModel.showAllActivities)
                
                CalendarView(viewModel: viewModel)
                
                if viewModel.showGoalCompleted {
                    GoalCompletedView(isPresented: $isPresented, viewModel: viewModel)
                }
                
                Spacer()
                
                if !viewModel.showGoalCompleted {
                    ActivityButtonsView(viewModel: viewModel)
                }
            }
        }
        .fullScreenCover(isPresented: $viewModel.showAllActivities) {
            AllActivitiesView(learnedDays: viewModel.learnedDays, freezedDays: viewModel.freezedDays)
        }
    }
}

// MARK: - Status Bar View
struct StatusBarView: View {
    var body: some View {
        HStack {
            Text("9:41")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
            Spacer()
            HStack(spacing: 8) {
                Image(systemName: "wifi")
                Image(systemName: "battery.100")
            }
            .font(.system(size: 16))
            .foregroundColor(.white)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
}

// MARK: - Header View
struct HeaderView: View {
    @Binding var showAllActivities: Bool
    
    var body: some View {
        HStack {
            Text("Activity")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: {
                    showAllActivities = true
                }) {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 36, height: 36)
                        .overlay(
                            Image(systemName: "calendar")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                        )
                }
                
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 36, height: 36)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
}

// MARK: - Calendar View
struct CalendarView: View {
    @ObservedObject var viewModel: ActivityViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            // شهر وسنة
            HStack {
                Button(action: {
                    viewModel.showMonthPicker.toggle()
                }) {
                    Text("\(viewModel.currentMonth) \(viewModel.currentYear)")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Image(systemName: viewModel.showMonthPicker ? "chevron.down" : "chevron.right")
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                HStack(spacing: 12) {
                    Button(action: {
                        viewModel.navigateWeek(direction: -1)
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color(red: 1.0, green: 0.5, blue: 0.2))
                    }
                    
                    Button(action: {
                        viewModel.navigateWeek(direction: 1)
                    }) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color(red: 1.0, green: 0.5, blue: 0.2))
                    }
                }
                .font(.system(size: 14, weight: .semibold))
            }
            .padding(.horizontal, 20)
            
            // عرض اختيار الشهر والسنة
            if viewModel.showMonthPicker {
                MonthPickerView(viewModel: viewModel)
            }
            
            // أيام الأسبوع
            WeekDaysHeaderView()
            
            // التواريخ
            WeekDaysView(viewModel: viewModel)
            
            // خط فاصل
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 1)
                .padding(.horizontal, 20)
            
            // إحصائيات التعلم
            LearningStatsView(viewModel: viewModel)
        }
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 0.1, green: 0.1, blue: 0.1))
        )
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
}

// MARK: - Month Picker View
struct MonthPickerView: View {
    @ObservedObject var viewModel: ActivityViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            Picker("Month", selection: $viewModel.currentMonth) {
                ForEach(["June", "July", "August", "September", "October", "November", "December"], id: \.self) { month in
                    Text(month)
                        .foregroundColor(.white)
                        .tag(month)
                }
            }
            .pickerStyle(.wheel)
            .colorMultiply(.white)
            
            Picker("Day", selection: .constant(17)) {
                ForEach(14...20, id: \.self) { day in
                    Text("\(day)")
                        .foregroundColor(.white)
                        .tag(day)
                }
            }
            .pickerStyle(.wheel)
            .colorMultiply(.white)
            
            Picker("Year", selection: $viewModel.currentYear) {
                ForEach(2018...2024, id: \.self) { year in
                    Text("\(year)")
                        .foregroundColor(.white)
                        .tag(year)
                }
            }
            .pickerStyle(.wheel)
            .colorMultiply(.white)
        }
        .padding(.horizontal, 20)
        .frame(height: 120)
    }
}

// MARK: - Week Days Header
struct WeekDaysHeaderView: View {
    var body: some View {
        HStack {
            ForEach(["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"], id: \.self) { day in
                Text(day)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Week Days View
struct WeekDaysView: View {
    @ObservedObject var viewModel: ActivityViewModel
    
    var body: some View {
        VStack(spacing: 6) {
            HStack(spacing: 8) {
                ForEach(viewModel.currentWeek, id: \.self) { day in
                    Button(action: {
                        viewModel.selectDay(day)
                    }) {
                        Text("\(day)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 32, height: 32)
                            .background(
                                Circle()
                                    .fill(viewModel.getDayColor(day: day))
                            )
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Learning Stats View
struct LearningStatsView: View {
    @ObservedObject var viewModel: ActivityViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Learning Swift")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
            
            HStack(spacing: 12) {
                // بطاقة الأيام المتعلمة
                HStack(spacing: 8) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 20))
                        .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.1))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(viewModel.daysLearned)")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(viewModel.daysLearned == 1 ? "Day Learned" : "Days Learned")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    Capsule()
                        .fill(Color(red: 0.2, green: 0.15, blue: 0.1))
                )
                
                // بطاقة الأيام المجمدة
                HStack(spacing: 8) {
                    Image(systemName: "cube.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.cyan)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(viewModel.daysFreezed)")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(viewModel.daysFreezed == 1 ? "Day Freezed" : "Days Freezed")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    Capsule()
                        .fill(Color(red: 0.1, green: 0.2, blue: 0.2))
                )
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Goal Completed View
struct GoalCompletedView: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: ActivityViewModel
    
    var body: some View {
        VStack(spacing: 15) {
            Text("👏")
                .font(.system(size: 60))
            
            Text("Well done!")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            Text("Goal completed! Start learning again or set new learning goal")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: {
                isPresented = false
            }) {
                Text("Set new learning goal")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(red: 0.8, green: 0.3, blue: 0.1))
                    )
            }
            .padding(.horizontal, 40)
            
            Button(action: {
                viewModel.resetGoal()
            }) {
                Text("Set same learning goal and duration")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.purple)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.purple, lineWidth: 1)
                    )
            }
            .padding(.horizontal, 40)
        }
        .padding(.vertical, 30)
    }
}

// MARK: - Activity Buttons View
struct ActivityButtonsView: View {
    @ObservedObject var viewModel: ActivityViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            // حالة بعد الضغط
            if viewModel.isDayLearned {
                LearnedTodayCircle()
            } else if viewModel.isDayFreezed {
                FreezedDayCircle()
            } else {
                LogAsLearnedButton(viewModel: viewModel)
            }
            
            // الزر السفلي - يتغير حسب الحالة
            if viewModel.isDayFreezed {
                ConvertToLearnedButton(viewModel: viewModel)
            } else {
                LogAsFreezedButton(viewModel: viewModel)
            }
            
            // النص يظهر دائماً
            FreezeCountText(viewModel: viewModel)
        }
        .padding(.bottom, 30)
    }
}

// MARK: - Learned Today Circle
struct LearnedTodayCircle: View {
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.orange, lineWidth: 3)
                .frame(width: 274, height: 274)
            
            Circle()
                .fill(Color(red: 0.2, green: 0.15, blue: 0.1))
                .frame(width: 264, height: 264)
            
            Text("Learned\nToday")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.orange)
                .multilineTextAlignment(.center)
        }
    }
}

// MARK: - Freezed Day Circle
struct FreezedDayCircle: View {
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color(red: 0.2, green: 0.6, blue: 0.9), lineWidth: 3)
                .frame(width: 274, height: 274)
            
            Circle()
                .fill(Color(red: 0.1, green: 0.2, blue: 0.2))
                .frame(width: 264, height: 264)
            
            Text("Day\nFreezed")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(Color(red: 0.3, green: 0.7, blue: 1.0))
                .multilineTextAlignment(.center)
        }
    }
}

// MARK: - Log As Learned Button
struct LogAsLearnedButton: View {
    @ObservedObject var viewModel: ActivityViewModel
    
    var body: some View {
        Button(action: {
            viewModel.logAsLearned()
        }) {
            Text("Log as\nLearned")
                .font(.system(size:30, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .frame(width: 274, height: 274)
                .background(
                    Circle()
                        .fill(Color(red: 0.8, green: 0.3, blue: 0.1))
                )
        }
    }
}

// MARK: - Convert To Learned Button
struct ConvertToLearnedButton: View {
    @ObservedObject var viewModel: ActivityViewModel
    
    var body: some View {
        Button(action: {
            viewModel.convertFreezedToLearned()
        }) {
            Text("Log as Learned")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 0.8, green: 0.3, blue: 0.1))
                )
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Log As Freezed Button
struct LogAsFreezedButton: View {
    @ObservedObject var viewModel: ActivityViewModel
    
    var body: some View {
        Button(action: {
            viewModel.logAsFreezed()
        }) {
            Text("Log as Freezed")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 0.1, green: 0.4, blue: 0.4))
                )
        }
        .disabled(viewModel.isDayLearned || viewModel.daysFreezed >= viewModel.totalFreezes)
        .opacity((viewModel.isDayLearned || viewModel.daysFreezed >= viewModel.totalFreezes) ? 0.5 : 1.0)
        .padding(.horizontal, 20)
    }
}

// MARK: - Freeze Count Text
struct FreezeCountText: View {
    @ObservedObject var viewModel: ActivityViewModel
    
    var body: some View {
        if viewModel.daysFreezed >= viewModel.totalFreezes {
            Text("All \(viewModel.totalFreezes) Freezes used")
                .font(.system(size: 10))
                .foregroundColor(.gray)
        } else {
            Text("\(viewModel.daysFreezed) out of \(viewModel.totalFreezes) Freezes used")
                .font(.system(size: 10))
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    @Previewable @State var isPresented = true
    let goal = LearningGoal(topic: "Swift", duration: .week, startDate: Date())
    return ActivityView(isPresented: $isPresented, learningGoal: goal)
}

