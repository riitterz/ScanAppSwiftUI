//
//  SearchLocationField.swift
//  ScanAppSwiftUI
//
//  Created by Macbook on 31/10/2024.
//

import SwiftUI

struct SearchLocationField: View {
    @Binding var searchText: String
    @Binding var isSearching: Bool
    let onClear: () -> Void
    
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color("White"))
                    .frame(height: 48)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(isSearching ? Color("Primary") : Color("PrimaryLight"), lineWidth: 1))
                HStack {
                    Image("search")
                        .renderingMode(.template)
                        .foregroundColor(Color("PrimaryExtraDark").opacity(0.5))
                   
                    ZStack(alignment: .leading) {
                        if searchText.isEmpty{
                            Text("Type location...")
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(Color("PrimaryExtraDark").opacity(0.5))
                        }
                        TextField("", text: $searchText) { editing in
                            isSearching = editing
                        }
                        .tint(Color("Info"))
                            .foregroundColor(Color("PrimaryExtraDark"))
                            .font(.system(size: 15, weight: .regular))
                    }
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                            onClear()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(Color.gray.opacity(0.7))
                        }
                        .padding(.leading, 8)
                    }
                }
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

