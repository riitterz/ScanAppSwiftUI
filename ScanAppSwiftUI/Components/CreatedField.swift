//
//  CreatedField.swift
//  ScanAppSwiftUI
//
//  Created by Macbook on 15/11/2024.
//

import SwiftUI

struct CreatedField: View {
    var title: String
    var isScanned: Bool
    
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color("White"))
                    .frame(height: 48)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color("PrimaryLight"), lineWidth: 1))
                HStack {
                        Text(title)
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(Color("PrimaryExtraDark"))
                            .lineLimit(1)
                    Spacer()
                    if isScanned {
                        Button {
                            UIPasteboard.general.string = title
                        } label: {
                            Image("copy")
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

