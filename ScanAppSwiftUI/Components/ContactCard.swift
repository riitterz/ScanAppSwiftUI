//
//  ContactCard.swift
//  ScanAppSwiftUI
//
//  Created by Macbook on 12/11/2024.
//

import SwiftUI
import Contacts

struct ContactCard: View {
    let contact: CNContact
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        HStack {
            if let imageData = contact.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 37, height: 37)
                    .clipShape(Circle())
            } else {
                Circle()
                    .frame(width: 37, height: 37)
                    .foregroundColor(Color(.systemGray4))
            }
            VStack(alignment: .leading) {
                Text("\(contact.givenName) \(contact.familyName)")
                    .font(.system(size: 17, weight: .regular))
                    .padding(.bottom, 1)
                    .foregroundColor(Color("PrimaryExtraDark"))
                if let phoneNumber = contact.phoneNumbers.first?.value.stringValue {
                    Text(phoneNumber)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color(.systemGray2))
                }
            }
        }
        .onTapGesture {
            onSelect()
        }
    }
}
