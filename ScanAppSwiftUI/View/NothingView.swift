//
//  NothingView.swift
//  ScanAppSwiftUI
//
//  Created by Macbook on 28/10/2024.
//

import SwiftUI

struct NothingView: View {
    var title: String
    var buttonImage: String
    var buttonTitle: String
    @Binding var selection: Int
    var targetTab: Int
    
    var body: some View {
        VStack(spacing: 8) {
            Image("nothing")
                .padding(.bottom, 20)
            Text("Nothing to show yet")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(Color("PrimaryExtraDark"))
            Text(title)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(Color("PrimaryExtraDark").opacity(0.5))

                .multilineTextAlignment(.center)
                .frame(width: 243)
                .padding(.bottom, 20)
            Button {
                selection = targetTab
            } label: {
                HStack(spacing: 12) {
                    Image(buttonImage)
                    Text(buttonTitle)
                        .font(.system(size: 19, weight: .semibold))
                        .foregroundColor(Color("PrimaryExtraLight"))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(Color("Primary"))
            .cornerRadius(24)
            .padding(.horizontal, 16)
        }

    }
}
