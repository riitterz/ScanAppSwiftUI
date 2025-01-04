//
//  ScannedView.swift
//  ScanAppSwiftUI
//
//  Created by Macbook on 22/11/2024.
//

import SwiftUI

struct ScannedView: View {
    @State var isSaved = false
    @State private var showSuccessMessage = true
    @State var codeColor: UIColor
    @State var backgroundColor: UIColor
    var isFromHistory: Bool = false
    @State var link: String
    @State private var showEditColorView: Bool = false

    var body: some View {
        ZStack {
            Color("PrimaryExtraLight")
                .ignoresSafeArea(.all)
            ScrollView(showsIndicators: false) {
                VStack {
                    ZStack(alignment: .top) {
                        QRCodeGenerate(url: link, codeColor: codeColor, backgroundColor: backgroundColor)
                            .frame(width: 256, height: 256)
                        
                        if showSuccessMessage && isSaved {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                Text("QR Code created successfully")
                                    .font(.system(size: 17, weight: .medium))
                                Spacer()
                                Image(systemName: "xmark")
                                    .onTapGesture {
                                        showSuccessMessage = false
                                    }
                            }
                            .foregroundColor(Color("White"))
                            .padding(16)
                            .background(Color.green)
                            .cornerRadius(16)
                            .padding(.horizontal, 16)
                        }
                    }
                }
            }
        }
    }
}


