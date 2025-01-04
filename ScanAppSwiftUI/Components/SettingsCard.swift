//
//  SettingsCard.swift
//  ScanAppSwiftUI
//
//  Created by Macbook on 27/10/2024.
//

import SwiftUI

struct SettingsCard: View {
    var image: String
    var title: String
    
    var body: some View {
        Link(destination: URL(string: "https://policies.google.com/terms?hl=en-US")!) {
            HStack {
                Image(image)
                Text(title)
                    .font(.system(size: 19, weight: .medium))
                    .foregroundColor(Color("PrimaryExtraDark"))
                    .padding(.leading, 5)
                Spacer()
                Image("arrowRight")
                    .renderingMode(.template)
                    .foregroundColor(Color("Primary"))
            }
            .padding(16)
            .background(Color("White"))
        .cornerRadius(24)
        }
    }
}

struct SettingsCard_Previews: PreviewProvider {
    static var previews: some View {
        SettingsCard(image: "rate", title: "Rate Us")
    }
}
