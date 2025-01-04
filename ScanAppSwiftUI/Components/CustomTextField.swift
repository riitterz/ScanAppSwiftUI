//
//  CustomTextField.swift
//  ScanAppSwiftUI
//
//  Created by Macbook on 30/10/2024.
//

import SwiftUI

struct CustomTextField: View {
    var title: String
    @Binding var enteredText: String
    @Binding var isText: Bool
    @FocusState private var isTextFielsFocused: Bool
    
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color("White"))
                    .frame(height: 48)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(isText ? Color("Primary") : Color("PrimaryLight"), lineWidth: 1))
                HStack {
                    ZStack(alignment: .leading) {
                        if enteredText.isEmpty{
                            Text(title)
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(Color("PrimaryExtraDark").opacity(0.5))
                        }
                        TextField("", text: $enteredText) { editing in
                            isText = editing
                        }
                        .tint(Color("Info"))
                        .foregroundColor(Color("PrimaryExtraDark"))
                            .font(.system(size: 15, weight: .regular))
                            .focused($isTextFielsFocused)
                    }
                }
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}
