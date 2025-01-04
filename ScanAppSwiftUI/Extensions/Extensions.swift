//
//  Extensions.swift
//  ScanAppSwiftUI
//
//  Created by Macbook on 18/11/2024.
//

import SwiftUI
import EventKit
import Contacts
import ContactsUI
import NetworkExtension
import UIKit

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

 func addToCalendar(name: String, location: String, startDate: Date, endDate: Date) {
    let eventStore = EKEventStore()
    
    eventStore.requestAccess(to: .event) { granted, error in
        guard granted, error == nil else {
            print("Access to calendar denied or error occurred \(String(describing: error?.localizedDescription))")
                  return
        }
        
        let event = EKEvent(eventStore: eventStore)
        event.title = name
        event.location = location
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        do {
            try eventStore.save(event, span: .thisEvent, commit: true)
            print("Event added to calendar")
        } catch let saveError {
            print("Failed to save event: \(saveError)")
        }
    }
}

func saveToContacts(firstName: String, familyName: String, phoneNumber: String) {
    let store = CNContactStore()

    let contact = CNMutableContact()
    contact.givenName = firstName
    contact.familyName = familyName
    contact.phoneNumbers = [CNLabeledValue(
        label: CNLabelPhoneNumberMobile,
        value: CNPhoneNumber(stringValue: phoneNumber)
    )]

    DispatchQueue.main.async {
        let contactVC = CNContactViewController(forNewContact: contact)
        contactVC.contactStore = store
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let rootViewController = windowScene.windows.first?.rootViewController {
            
            var topController = rootViewController
            while let presentedController = topController.presentedViewController {
                topController = presentedController
            }

            topController.present(UINavigationController(rootViewController: contactVC), animated: true, completion: nil)
        }
    }
}


 func openContact(number: String) {
    let contactStore = CNContactStore()
    
    contactStore.requestAccess(for: .contacts) { granted, error in
        guard granted, error == nil else {
            print("Access to contacts denied or error occurred: \(String(describing: error?.localizedDescription))")
            return
        }
        
        let contact = CNMutableContact()
        contact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberMobile, value: CNPhoneNumber(stringValue: number))]
        
        DispatchQueue.main.async {
            let contactVC = CNContactViewController(forNewContact: contact)
            contactVC.contactStore = contactStore
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let rootViewController = windowScene.windows.first?.rootViewController {
                
                var topController = rootViewController
                while let presentedController = topController.presentedViewController {
                    topController = presentedController
                }

                topController.present(UINavigationController(rootViewController: contactVC), animated: true, completion: nil)
            }
        }
    }
}

func connectToWiFi(ssid: String, password: String, encryption: String) {
    let configuration: NEHotspotConfiguration
    
    if encryption.lowercased() == "nopass" {
        configuration = NEHotspotConfiguration(ssid: ssid)
    } else {
        configuration = NEHotspotConfiguration(ssid: ssid, passphrase: password, isWEP: encryption.lowercased() == "wep")
    }
    
    NEHotspotConfigurationManager.shared.apply(configuration) { error in
        if let error = error as NSError? {
            switch error.code {
            case NEHotspotConfigurationError.alreadyAssociated.rawValue:
                print("DEBUG: Already connected to \(ssid)")
            case NEHotspotConfigurationError.userDenied.rawValue:
                print("DEBUG: User denied Wi-Fi connection to \(ssid)")
            case NEHotspotConfigurationError.invalid.rawValue:
                print("DEBUG: Invalid Wi-Fi configuration for \(ssid)")
            case NEHotspotConfigurationError.internal.rawValue:
                print("DEBUG: Internal error while connecting to \(ssid)")
            default:
                print("DEBUG: Failed to connect to \(ssid) - \(error.localizedDescription)")
            }
        } else {
            print("DEBUG: Successfully connected to \(ssid)")
        }
    }
}

