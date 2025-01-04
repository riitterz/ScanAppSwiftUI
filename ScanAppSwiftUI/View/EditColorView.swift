//
//  EditColorView.swift
//  ScanAppSwiftUI
//
//  Created by Macbook on 18/11/2024.
//

import SwiftUI

struct EditColorView: View {
    @Binding var showEditColorView: Bool
    @Binding var codeColor: UIColor
    @Binding var backgroundColor: UIColor

    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("White"))
                    .frame(width: 36, height: 5)
                
                Image("close")
                    .onTapGesture {
                        withAnimation {
                            showEditColorView = false
                        }
                    }
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity, alignment: .trailing)

                Text("Color Picker")
                    .offset(x: 0, y: -25)
                    .foregroundColor(Color("PrimaryExtraDark"))
                    .font(.system(size: 19, weight: .medium))
                Divider()
                    .padding(.bottom, 20)
                    .offset(x: 0, y: -10)

                VStack(spacing: 8) {
                    ColorCard(title: "Background Color", color: $backgroundColor)
                    ColorCard(title: "QR Code Color", color: $codeColor)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)

            }
            .padding(.top, 5)
            .padding(.bottom, 40)
            .background(Color("PrimaryExtraLight"))
            .cornerRadius(16, corners: [.topLeft, .topRight])
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}


