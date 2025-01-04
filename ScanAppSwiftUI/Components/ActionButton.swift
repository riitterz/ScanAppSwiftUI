//
//  ActionButton.swift
//  ScanAppSwiftUI
//
//  Created by Macbook on 15/11/2024.
//

import SwiftUI

struct ActionButton: View {
    var image: String
    var action: (() -> Void)? = nil

    var body: some View {
        Button {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            action?()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color("White"))
                    .frame(height: 56)
                    .overlay(RoundedRectangle(cornerRadius: 24).stroke( Color("PrimaryLight"), lineWidth: 1))
                Image(image)
            }
            .frame(maxWidth: .infinity)
        }

    }
}

struct ActionButton_Previews: PreviewProvider {
    static var previews: some View {
        ActionButton(image: "color")
    }
}
