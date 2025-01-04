//
//  QRCard.swift
//  ScanAppSwiftUI
//
//  Created by Macbook on 15/11/2024.
//

import SwiftUI
import Foundation
import UIKit

class QRCard: NSObject, NSCoding, Identifiable {
    let id = UUID()
    let qrString: String
    var startTime: Date
    var endTime: Date
    var name: String
    var lastName: String
    var title: String
    var link: String
    var text: String
    var number: String
    var location: String
    var encryption: String
    var address: String
    var currency: String
    var email: String
    var subject: String
    var message: String
    var amount: String
    var codeColor: UIColor
    var backgroundColor: UIColor
    var image: String
    var qrType: QRType
    var ssid: String
    var password: String

    init(
        qrString: String,
        startTime: Date,
        endTime: Date,
        name: String,
        lastName: String,
        title: String,
        link: String,
        text: String,
        number: String,
        location: String,
        encryption: String,
        address: String,
        currency: String,
        email: String,
        subject: String,
        message: String,
        amount: String,
        codeColor: UIColor,
        backgroundColor: UIColor,
        image: String,
        qrType: QRType,
        ssid: String,
        password: String
    ) {
        self.qrString = qrString
        self.startTime = startTime
        self.endTime = endTime
        self.name = name
        self.lastName = lastName
        self.title = title
        self.link = link
        self.text = text
        self.number = number
        self.location = location
        self.encryption = encryption
        self.address = address
        self.currency = currency
        self.email = email
        self.subject = subject
        self.message = message
        self.amount = amount
        self.codeColor = codeColor
        self.backgroundColor = backgroundColor
        self.image = image
        self.qrType = qrType
        self.ssid = ssid
        self.password = password
    }

    required init?(coder: NSCoder) {
        self.qrString = coder.decodeObject(forKey: "qrString") as? String ?? ""
        self.startTime = coder.decodeObject(forKey: "startTime") as? Date ?? Date()
        self.endTime = coder.decodeObject(forKey: "endTime") as? Date ?? Date()
        self.name = coder.decodeObject(forKey: "name") as? String ?? ""
        self.lastName = coder.decodeObject(forKey: "lastName") as? String ?? ""
        self.title = coder.decodeObject(forKey: "title") as? String ?? ""
        self.link = coder.decodeObject(forKey: "link") as? String ?? ""
        self.text = coder.decodeObject(forKey: "text") as? String ?? ""
        self.number = coder.decodeObject(forKey: "number") as? String ?? ""
        self.location = coder.decodeObject(forKey: "location") as? String ?? ""
        self.encryption = coder.decodeObject(forKey: "encryption") as? String ?? ""
        self.address = coder.decodeObject(forKey: "address") as? String ?? ""
        self.currency = coder.decodeObject(forKey: "currency") as? String ?? ""
        self.email = coder.decodeObject(forKey: "email") as? String ?? ""
        self.subject = coder.decodeObject(forKey: "subject") as? String ?? ""
        self.message = coder.decodeObject(forKey: "message") as? String ?? ""
        self.amount = coder.decodeObject(forKey: "amount") as? String ?? ""
        self.codeColor = coder.decodeObject(forKey: "codeColor") as? UIColor ?? .black
        self.backgroundColor = coder.decodeObject(forKey: "backgroundColor") as? UIColor ?? .white
        self.image = coder.decodeObject(forKey: "image") as? String ?? ""
        self.qrType = coder.decodeObject(forKey: "qrType") as! QRType
        self.ssid = coder.decodeObject(forKey: "ssid") as? String ?? ""
        self.password = coder.decodeObject(forKey: "password") as? String ?? ""
    }

    func encode(with coder: NSCoder) {
        coder.encode(qrString, forKey: "qrString")
        coder.encode(startTime, forKey: "startTime")
        coder.encode(endTime, forKey: "endTime")
        coder.encode(name, forKey: "name")
        coder.encode(lastName, forKey: "lastName")
        coder.encode(title, forKey: "title")
        coder.encode(link, forKey: "link")
        coder.encode(text, forKey: "text")
        coder.encode(number, forKey: "number")
        coder.encode(location, forKey: "location")
        coder.encode(encryption, forKey: "encryption")
        coder.encode(address, forKey: "address")
        coder.encode(currency, forKey: "currency")
        coder.encode(email, forKey: "email")
        coder.encode(subject, forKey: "subject")
        coder.encode(message, forKey: "message")
        coder.encode(amount, forKey: "amount")
        coder.encode(codeColor, forKey: "codeColor")
        coder.encode(backgroundColor, forKey: "backgroundColor")
        coder.encode(image, forKey: "image")
        coder.encode(qrType, forKey: "qrType")
        coder.encode(ssid, forKey: "ssid")
        coder.encode(password, forKey: "password")
    }
}

class QRCodeStorage: ObservableObject {
    @Published var savedQRCodes: [QRCard] = [] {
        didSet { saveToUserDefaults(key: savedKey, cards: savedQRCodes) }
    }
    @Published var imagePickerQRCodes: [QRCard] = [] {
        didSet { saveToUserDefaults(key: imagePickerKey, cards: imagePickerQRCodes) }
    }

    private let savedKey = "SavedQRCodes"
    private let imagePickerKey = "ImagePickerQRCodes"

    init() {
        print("QRCodeStorage initialized.")
        self.savedQRCodes = loadFromUserDefaults(key: savedKey)
        self.imagePickerQRCodes = loadFromUserDefaults(key: imagePickerKey)
    }

    private func saveToUserDefaults(key: String, cards: [QRCard]) {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: cards, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: key)
            print("Saved \(cards.count) QR codes to \(key).")
        } catch {
            print("Failed to save QR codes: \(error)")
        }
    }

    private func loadFromUserDefaults(key: String) -> [QRCard] {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            print("No data found for key: \(key).")
            return []
        }
        do {
            if let cards = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [QRCard] {
                print("Loaded \(cards.count) QR codes from \(key).")
                return cards
            }
        } catch {
            print("Failed to load QR codes: \(error)")
        }
        return []
    }

    func updateQRCode(_ updatedQRCode: QRCard) {
        if let index = savedQRCodes.firstIndex(where: { $0.qrString == updatedQRCode.qrString }) {
            savedQRCodes[index] = updatedQRCode
        } else if let index = imagePickerQRCodes.firstIndex(where: { $0.qrString == updatedQRCode.qrString }) {
            imagePickerQRCodes[index] = updatedQRCode
        }
    }
}
