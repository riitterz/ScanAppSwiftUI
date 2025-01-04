//
//  CustomSegmentedControl.swift
//  ScanAppSwiftUI
//
//  Created by Macbook on 03/11/2024.
//

import SwiftUI

struct CustomSegmentedControl: View {
    
    @Binding var selected: Int
    
    var body: some View {
        HStack {
            Button {
                self.selected = 0
            } label: {
                Text("Scanned")
                    .font(.system(size: 19, weight: .medium))
                    .foregroundColor(self.selected == 0 ? Color("White") : Color("Primary"))
                    .frame(height: 28)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 16)
            }
            .frame(maxWidth: .infinity)
            .background(self.selected == 0 ? Color("Primary") : Color.clear)
            .cornerRadius(16)

            Button {
                self.selected = 1
            } label: {
                Text("Created")
                    .font(.system(size: 19, weight: .medium))
                    .foregroundColor(self.selected == 1 ? Color("White") : Color("Primary"))
                    .frame(height: 28)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 16)
            }
            .frame(maxWidth: .infinity)
            .background(self.selected == 1 ? Color("Primary") : Color.clear)
            .cornerRadius(16)

        }
        .frame(maxWidth: .infinity)
        .background(Color("White"))
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color("PrimaryLight"), lineWidth: 1))

    }
}

