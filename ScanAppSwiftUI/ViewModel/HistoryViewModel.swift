//
//  HistoryViewModel.swift
//  ScanAppSwiftUI
//
//  Created by Macbook on 15/12/2024.
//

import Foundation

class HistoryViewModel: ObservableObject {
    @Published var selectedCode: QRCard? = nil
    @Published var isFullScreenPresented: Bool = false
}
