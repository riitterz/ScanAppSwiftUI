//
//  ContactsView.swift
//  ScanAppSwiftUI
//
//  Created by Macbook on 12/11/2024.
//

import SwiftUI
import Contacts

struct ContactsView: View {
    @ObservedObject var manager = ContactModel()
    @State private var searchText = ""
    var onSelectContact: (String, String, String) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color("PrimaryExtraLight")
                .ignoresSafeArea(.all)
            VStack(spacing: 0) {
                List {
                    ForEach(filteredSection(), id: \.self) { section in
                        Section(header: sectionHeader(for: section)) {
                            ForEach(filteredContacts(in: section), id: \.identifier) { contact in
                                ContactCard(contact: contact, isSelected: manager.isContactSelected(contact)) {
                                    let givenName = contact.givenName
                                    let familyName = contact.familyName
                                    let phoneNumber = contact.phoneNumbers.first?.value.stringValue ?? ""
                                    onSelectContact(givenName, familyName, phoneNumber)
                                    dismiss()
                                }
                                .listRowBackground(Color("White"))
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .background(Color.clear)
            }
            .navigationBarBackButtonHidden(true)
            .searchable(text: $searchText)
            .padding(.top, 5)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButton()
                }
                ToolbarItem(placement: .principal) {
                    Text("Contacts")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(Color("PrimaryExtraDark"))
                }
            }

        }
    }
    
    func filteredSection() -> [String] {
        let sections = sortedSection()
        return sections.filter { section in
            !filteredContacts(in: section).isEmpty
        }
    }
    
    func filteredContacts(in section: String) -> [CNContact] {
        let contacts = manager.contactsBySection[section] ?? []
        if searchText.isEmpty {
            return contacts
        } else {
            return contacts.filter { contact in
                contact.givenName.localizedCaseInsensitiveContains(searchText) || contact.familyName.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    func sectionHeader(for section: String) -> some View {
        HStack {
            Text(section)
        }
    }
    
    func sortedSection() -> [String] {
        return manager.contactsBySection.keys.sorted()
    }
}


