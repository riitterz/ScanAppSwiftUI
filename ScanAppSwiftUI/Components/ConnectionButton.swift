//
//  ConnectionButton.swift
//  ScanAppSwiftUI
//
//  Created by Macbook on 21/12/2024.
//

import SwiftUI

struct ConnectionButton: View {
    var image: String
    var title: String
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color("White"))
                .frame(height: 56)
                .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color("PrimaryLight"), lineWidth: 1))
            HStack(spacing: 12) {
                Image(image)
                    .resizable()
                    .frame(width: 25, height: 25)
                Text(title)
                    .font(.system(size: 19, weight: .medium))
                    .foregroundColor(Color("Primary"))
            }
        }
    }
}
