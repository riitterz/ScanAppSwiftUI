//
//  HistoryView.swift
//  ScanAppSwiftUI
//
//  Created by Macbook on 28/10/2024.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var qrCodeStorage: QRCodeStorage
    @Binding var selection: Int
    @State private var selected = 0
    @State private var qrType = QRType()
    @State private var isSettingsPresentable = false
    @StateObject private var viewModel = HistoryViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                Color("PrimaryExtraLight")
                    .ignoresSafeArea(.all)
                VStack {
                    CustomSegmentedControl(selected: $selected)
                    Spacer()
                    ChosenTypeView(
                        qrCodeStorage: _qrCodeStorage,
                        selected: selected,
                        selection: $selection,
                        qrType: qrType,
                        viewModel: viewModel)
                    .padding(.bottom, 70)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity)
                .padding(.top, -20)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { } label: { Image("pro") }
                }
                ToolbarItem(placement: .principal) {
                    Text("History")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(Color("PrimaryExtraDark"))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image("settings")
                        .onTapGesture { isSettingsPresentable = true }
                        .fullScreenCover(isPresented: $isSettingsPresentable) {
                            SettingsView()
                        }
                }
            }
        }
        .fullScreenCover(isPresented: $viewModel.isFullScreenPresented) {
            if let code = viewModel.selectedCode {
                GeneratedView(
                    name: code.name,
                    lastName: code.lastName,
                    title: code.title,
                    link: code.qrString,
                    text: code.text,
                    number: code.number,
                    location: code.location,
                    encryption: code.encryption,
                    address: code.address,
                    currency: code.currency,
                    email: code.email,
                    subject: code.subject,
                    message: code.message,
                    amount: code.amount,
                    codeColor: UIColor(Color("\(code.codeColor)")) ,
                    backgroundColor: code.backgroundColor,
                    qrImage: code.image,
                    isFromHistory: true,
                    qrType: code.qrType,
                    ssid: code.ssid,
                    password: code.password) {
                        viewModel.isFullScreenPresented = false
                    }
            } else {
                Text("Error: No QR Code Selected")
                    .background(Color.red)
            }
        }
    }
}

struct ChosenTypeView: View {
    @EnvironmentObject var qrCodeStorage: QRCodeStorage
    var selected = 0
    @Binding var selection: Int
    var qrType: QRType
    @ObservedObject var viewModel: HistoryViewModel

    var body: some View {
        VStack {
            if selected == 0 {
                if qrCodeStorage.imagePickerQRCodes.isEmpty {
                    NothingView(
                        title: "Tap the button below to initiate the code scan",
                        buttonImage: "scan",
                        buttonTitle: "Scan QR Code",
                        selection: $selection,
                        targetTab: 1
                    )
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 8) {
                            ForEach(qrCodeStorage.imagePickerQRCodes) { code in
                                CreatedCard(image: Image(code.image), name: code.title, title: code.qrType.title)
                                    .onTapGesture {
                                        viewModel.selectedCode = code
                                        viewModel.isFullScreenPresented = true
                                    }
                            }
                        }
                    }
                }
            } else {
                if qrCodeStorage.savedQRCodes.isEmpty {
                    NothingView(
                        title: "Tap the button below to generate the QR code",
                        buttonImage: "plus",
                        buttonTitle: "Create QR Code",
                        selection: $selection,
                        targetTab: 2
                    )
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 8) {
                            ForEach(qrCodeStorage.savedQRCodes) { code in
                                CreatedCard(image: Image(code.image), name: code.title, title: code.qrType.title)
                                    .onTapGesture {
                                        viewModel.selectedCode = code
                                        viewModel.isFullScreenPresented = true
                                    }
                            }
                        }
                    }
                }
            }
        }
    }
}
