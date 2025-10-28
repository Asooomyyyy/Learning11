//
//  DurationButton.swift
//  Learning
//
//  Created by Asma Abdullah Suliman on 26/04/1447 AH.
//

import SwiftUI

struct DurationButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color(red: 0.8, green: 0.3, blue: 0.1) : Color(red: 0.2, green: 0.2, blue: 0.2))
                        .shadow(color: isSelected ? Color(red: 0.8, green: 0.3, blue: 0.1).opacity(0.3) : Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
                )
        }
    }
}

