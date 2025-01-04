//
//  ColorCard.swift
//  ScanAppSwiftUI
//
//  Created by Macbook on 18/11/2024.
//

import SwiftUI

struct ColorCard: View {
    var title: String
    @Binding var color: UIColor
    
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color("White"))
                    .frame(height: 56)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color("PrimaryLight"), lineWidth: 1))
                HStack(spacing: 16) {
                    ColorPicker("", selection: Binding(get: {Color(color)}, set: { newColor in color = UIColor(newColor)}))
                        .labelsHidden()
                        Text(title)
                                .font(.system(size: 17, weight: .medium))
                                .foregroundColor(Color("Primary"))
                    Spacer()
                }
                .padding(.horizontal, 16)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

}

