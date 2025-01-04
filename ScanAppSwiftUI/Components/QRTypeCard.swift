//
//  QRTypeCard.swift
//  ScanAppSwiftUI
//
//  Created by Macbook on 28/10/2024.
//

import SwiftUI

struct QRTypeCard: View {
    var image: UIImage
    var title: String
    
    var body: some View {
        VStack {
            Image(uiImage: image)
            Text(title)
                .font(.system(size: 19, weight: .medium))
                .foregroundColor(Color("PrimaryExtraDark"))
        }
        .frame(height: 132)
        .frame(maxWidth: .infinity)
        .background(Color("Card"))
        .overlay(RoundedRectangle(cornerRadius: 32)
            .stroke(Color("PrimaryLight"), lineWidth: 1))
        .cornerRadius(32)
    }
}

