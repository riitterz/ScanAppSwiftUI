//
//  CreatedCard.swift
//  ScanAppSwiftUI
//
//  Created by Macbook on 16/11/2024.
//

import SwiftUI

struct CreatedCard: View {
    var image: Image
    var name: String
    var title: String
    
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color("White"))
                    .frame(height: 64)
                    .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color("PrimaryLight"), lineWidth: 1))
                HStack(spacing: 16) {
                    image
                        .resizable()
                        .frame(width: 32, height: 32)
                    VStack(alignment: .leading, spacing: 5) {
                        Text(name)
                            .lineLimit(1)
                            .font(.system(size: 19, weight: .medium))
                            .foregroundColor(Color("PrimaryExtraDark"))
                        Text(title)
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(Color("PrimaryExtraDark").opacity(0.5))
                    }
                    Spacer()
                    Image("arrowRight")
                        .renderingMode(.template)
                        .foregroundColor(Color("PrimaryExtraDark").opacity(0.5))
                }
                .padding(.horizontal, 16)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

