//
//  HomeView.swift
//  Learning
//
//  Created by Asma Abdullah Suliman on 26/04/1447 AH.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = LearningViewModel()
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                ZStack {
                    Circle()
                        .fill(Color(red: 0.1, green: 0.05, blue: 0.02))
                        .frame(width: 100, height: 100)
                        .shadow(color: Color(red: 0.2, green: 0.1, blue: 0.05), radius: 10, x: 0, y: 5)
                    
                    Image(systemName: "flame.fill")
                        .font(.system(size: 40))
                        .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.1))
                }
                .padding(.top, 50)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Hello Learner")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("This app will help you learn everyday!")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white.opacity(0.8))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                
                // حقل إدخال الموضوع
                VStack(alignment: .leading, spacing: 12) {
                    Text("I want to learn")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                    
                    TextField("Swift", text: $viewModel.learningTopic)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.gray.opacity(0.5))
                                .offset(y: 20)
                        )
                }
                .padding(.horizontal, 20)
                
                // أزرار اختيار المدة
                VStack(alignment: .leading, spacing: 12) {
                    Text("I want to learn it in a")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                    
                    HStack(spacing: 12) {
                        DurationButton(title: "Week", isSelected: viewModel.selectedDuration == .week) {
                            viewModel.selectedDuration = .week
                        }
                        
                        DurationButton(title: "Month", isSelected: viewModel.selectedDuration == .month) {
                            viewModel.selectedDuration = .month
                        }
                        
                        DurationButton(title: "Year", isSelected: viewModel.selectedDuration == .year) {
                            viewModel.selectedDuration = .year
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // زر البدء
                Button(action: {
                    viewModel.startLearning()
                }) {
                    Text("Start learning")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color(red: 0.8, green: 0.3, blue: 0.1))
                                .shadow(color: Color(red: 0.8, green: 0.3, blue: 0.1).opacity(0.3), radius: 10, x: 0, y: 5)
                        )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .fullScreenCover(isPresented: $viewModel.showActivity) {
            ActivityView(isPresented: $viewModel.showActivity, learningGoal: viewModel.createLearningGoal())
        }
    }
}

#Preview {
    HomeView()
}

