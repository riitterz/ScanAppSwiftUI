//
//  SettingsView.swift
//  ScanAppSwiftUI
//
//  Created by Macbook on 27/10/2024.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationView {
            ZStack {
                Color("PrimaryExtraLight")
                    .ignoresSafeArea(.all)
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 8) {
                        SettingsCard(image: "share", title: "Share App")
                        SettingsCard(image: "restore", title: "Restore Purchases")
                        SettingsCard(image: "rate", title: "Rate Us")
                        SettingsCard(image: "contact", title: "Contact Us")
                        SettingsCard(image: "terms", title: "Terms of Use")
                        SettingsCard(image: "privacy", title: "Privacy Policy")
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.top, -20)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                                      ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image("back")
                        }
                    }
                    ToolbarItem(placement: .principal) {
                        Text("Settings")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(Color("PrimaryExtraDark"))
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
