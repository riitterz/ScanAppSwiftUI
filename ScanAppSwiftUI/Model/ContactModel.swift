//
//  ContactModel.swift
//  ScanAppSwiftUI
//
//  Created by Macbook on 12/11/2024.
//

import SwiftUI
import Contacts

class ContactModel: ObservableObject {
    @Published var contacts = [CNContact]()
    @Published var contactsBySection = [String: [CNContact]]()
    @Published var selectedContants = Set<CNContact>()
    
    private let contactStore = CNContactStore()
    
    init() {
        requestAccess()
    }
    
    private func requestAccess() {
        contactStore.requestAccess(for: .contacts) { granted, error in
            if granted {
                self.fetchContacts()
            } else {
                print("Access denied")
            }
        }
    }
    
    private func fetchContacts() {
        let keysToFetch: [CNKeyDescriptor] = [CNContactGivenNameKey as CNKeyDescriptor,
                                              CNContactFamilyNameKey as CNKeyDescriptor,
                                              CNContactPhoneNumbersKey as CNKeyDescriptor,
                                              CNContactImageDataKey as CNKeyDescriptor]
        
        let request = CNContactFetchRequest(keysToFetch: keysToFetch)
        
        DispatchQueue.global(qos: .userInitiated).async {
            var contacts = [CNContact]()
            do {
                try self.contactStore.enumerateContacts(with: request) { contact, stop in
                    contacts.append(contact)
                }
                DispatchQueue.main.async {
                    self.groupContacts(contacts: contacts)
                }
            } catch {
                print("Failed to fetch contacts:", error)
            }
        }
    }
    
    func groupContacts(contacts: [CNContact]) {
        let grouped = Dictionary(grouping: contacts) { contact in
            return String(contact.givenName.prefix(1)).uppercased()
        }
        self.contactsBySection = grouped
    }
    
    func toggleSection(for contact: CNContact) {
        if selectedContants.contains(contact) {
            selectedContants.remove(contact)
        } else {
            selectedContants.insert(contact)
        }
    }
    
    func isContactSelected(_ contact: CNContact) -> Bool {
        return selectedContants.contains(contact)
    }
}
