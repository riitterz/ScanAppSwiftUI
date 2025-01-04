//
//  CreateQRView.swift
//  ScanAppSwiftUI
//
//  Created by Macbook on 28/10/2024.
//

import SwiftUI

struct CreateQRView: View {
    @State private var selectedQRType: QRType?
    @State private var isSheetPresentable = false
    @State private var isSettingsPresentable = false

    var body: some View {
        NavigationView {
            ZStack {
                Color("PrimaryExtraLight")
                    .ignoresSafeArea(.all)
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        Text("Pick the type of QR Code")
                            .font(.system(size: 19, weight: .medium))
                            .foregroundColor(Color("PrimaryExtraDark").opacity(0.5))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                            ForEach(qrTypes.filter { $0.title != "General" }, id: \.self) { type in
                                QRTypeCard(image: UIImage(named: type.image)!, title: type.title)
                                    .onTapGesture {
                                        selectedQRType = type
                                        isSheetPresentable = true
                                    }
                            }
                        }
                        ForEach(qrTypes.filter { $0.title == "General" }, id: \.self) { type in
                            HStack(spacing: 16) {
                                Image("qr")
                                Text("\(type.title) QR Code")
                                    .font(.system(size: 19, weight: .medium))
                                    .foregroundColor(Color("PrimaryExtraDark"))
                            }
                            .padding(.horizontal, 16)
                            .frame(height: 88)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color("Card"))
                            .overlay(RoundedRectangle(cornerRadius: 32)
                                .stroke(Color("PrimaryLight"), lineWidth: 1))
                            .cornerRadius(32)
                            .onTapGesture {
                                selectedQRType = type
                                isSheetPresentable = true
                            }
                        }
                        .onChange(of: selectedQRType, perform: { newValue in
                            isSheetPresentable = newValue != nil
                        })
                        .fullScreenCover(isPresented: $isSheetPresentable) {
                            if let selectedQRType = selectedQRType {
                                QRTypeCardDetailView(qrType: selectedQRType)
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                }
                .statusBarHidden(true)
                .padding(.top, -20)
                .padding(.bottom, 70)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        
                    } label: {
                        Image("pro")
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("Create QR Code")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(Color("PrimaryExtraDark"))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image("settings")
                        .onTapGesture {
                            isSettingsPresentable = true
                        }
                        .fullScreenCover(isPresented: $isSettingsPresentable) {
                            SettingsView()
                        }
                }
            }
        }
    }
}

class QRType: NSObject, NSCoding {
    var image: String
    var title: String

    init(image: String = "", title: String = "") {
        self.image = image
        self.title = title
    }

    func encode(with coder: NSCoder) {
        coder.encode(image, forKey: "image")
        coder.encode(title, forKey: "title")
    }

    required init(coder: NSCoder) {
        self.image = coder.decodeObject(forKey: "image") as? String ?? ""
        self.title = coder.decodeObject(forKey: "title") as? String ?? ""
    }
}

var qrTypes = [
    QRType(image: "web", title: "Website"),
    QRType(image: "text", title: "Text"),
    QRType(image: "date", title: "Event"),
    QRType(image: "user", title: "Contact"),
    QRType(image: "email", title: "Email"),
    QRType(image: "location", title: "Location"),
    QRType(image: "wifi", title: "Wi-Fi"),
    QRType(image: "phone", title: "Phone"),
    QRType(image: "crypto", title: "Crypto"),
    QRType(image: "qr", title: "General")
]


