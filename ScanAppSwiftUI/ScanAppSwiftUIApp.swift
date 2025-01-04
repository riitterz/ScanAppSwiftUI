//
//  ScanAppSwiftUIApp.swift
//  ScanAppSwiftUI
//
//  Created by Macbook on 27/10/2024.
//

import SwiftUI

@main
struct ScanAppSwiftUIApp: App {
    @StateObject private var qrCodeStorage = QRCodeStorage()
    var body: some Scene {
        WindowGroup {
            TabBarView()
                .environmentObject(qrCodeStorage)
                .preferredColorScheme(.light)
        }
    }
}
