//
//  LocationCard.swift
//  ScanAppSwiftUI
//
//  Created by Macbook on 09/11/2024.
//

import SwiftUI
import MapKit

struct LocationCard: View {
    let location: MKMapItem
    let onSelect: () -> Void
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color("White"))
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color("PrimaryLight"), lineWidth: 1))
                HStack(spacing: 8) {
                    Image("location")
                        .resizable()
                        .frame(width: 48, height: 48)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(location.name ?? "Unknown Location")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(Color("PrimaryExtraDark"))
                        if let address = location.placemark.title {
                            Text(address)
                                .font(.subheadline)
                                .foregroundColor(Color("PrimaryExtraDark").opacity(0.5))
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .onTapGesture {
            onSelect()
        }
    }
}

