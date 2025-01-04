//
//  TabBarView.swift
//  ScanAppSwiftUI
//
//  Created by Macbook on 28/10/2024.
//

import SwiftUI

struct TabBarView: View {
    @State private var selection = 1
    @State private var isGeneratedViewActive = false

    var body: some View {
        ZStack {
            TabView(selection: $selection) {
                ScanView()
                    .tag(1)
                CreateQRView()
                    .tag(2)
                HistoryView(selection: $selection)
                    .tag(3)
            }
            if !isGeneratedViewActive {
                VStack {
                    Spacer()
                    CustomTabView(selection: $selection)
                        .padding(.top, 30)
                        .padding(.bottom, 10)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color("PrimaryExtraLight").opacity(0.99),
                                    Color("PrimaryExtraLight")
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            ))
                        .allowsHitTesting(!isGeneratedViewActive)

                }
                .transition(.move(edge: .bottom))
            }
        }
        .animation(.easeInOut, value: isGeneratedViewActive)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
