//
//  CustomTabView.swift
//  ScanAppSwiftUI
//
//  Created by Macbook on 28/10/2024.
//

import SwiftUI

struct CustomTabView: View {
    @Binding var selection: Int
    let tabItems: [(image: String, title: String)] = [
    ("scan", "Scan"),
    ("qr", "Create QR"),
    ("history", "History")
    ]
    
    var body: some View {
        ZStack {
            Capsule()
                .frame(height: 82)
                .foregroundColor(Color("White"))
            HStack {
                ForEach(0..<3) { index in
                    Button {
                        selection = index + 1
                    } label: {
                        VStack(spacing: 4) {
                            Spacer()
                            Image(index + 1 == selection ? "\(tabItems[index].image)True" : "\(tabItems[index].image)False")
                                .renderingMode(.template)
                            Text(tabItems[index].title)
                                .font(.system(size: 12, weight: .medium))
                        }
                        .foregroundColor(index + 1 == selection ? Color("Primary") : Color("Primary").opacity(0.6))

                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.vertical)
            .frame(height: 82)
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 16)
        
    }
}

struct CustomTabView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabView(selection: .constant(1))
    }
}
