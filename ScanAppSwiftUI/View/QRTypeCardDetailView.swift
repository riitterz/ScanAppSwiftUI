//
//  QRTypeCardDetailView.swift
//  ScanAppSwiftUI
//
//  Created by Macbook on 29/10/2024.
//

import SwiftUI
import MapKit

enum WifiSelection: String, CaseIterable {
    case noEncryption = "no encryption"
    case wep = "WEP"
    case wpa = "WPA/WPA2"
}

enum CryptoSelection: String, CaseIterable {
    case btc = "BTC"
    case eth = "ETH"
    case trx = "TRX"
    case sol = "SOL"
}

struct QRTypeCardDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var locationViewModel = LocationSearchViewModel()
    @State private var navigateToContactsView = false
    let qrType: QRType
    @State private var enteredLocation: String = ""
    @State private var enteredName: String = ""
    @State private var enteredLink: String = ""
    @State private var enteredPassword: String = ""
    @State private var enteredNumber: String = ""
    @State private var enteredMessage: String = ""
    @State private var isSearch: Bool = false
    @State private var isEnterName: Bool = false
    @State private var isEnterLink: Bool = false
    @State private var isEnterMessage: Bool = false
    @State private var wifiSelection: WifiSelection = .noEncryption
    @State private var cryptoSelection: CryptoSelection = .btc
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var isGenerating = false
    @State private var selectedLocation: MKMapItem? = nil
    
    private var isFormValid: Bool {
        switch qrType.title {
        case "Website":
            return !enteredLink.isEmpty
        case "Wi-Fi":
            return !enteredLink.isEmpty
        case "Text", "Event", "Contact", "Email", "Location", "Phone":
            return !enteredName.isEmpty
        case "Crypto":
            return !enteredName.isEmpty && !enteredPassword.isEmpty
        case "General":
            return !enteredName.isEmpty && !enteredLink.isEmpty
        default:
            return false
        }
    }
    
    private var generatedQRCodeString: String {
        switch qrType.title {
        case "Website":
            guard let url = URL(string: enteredLink), url.scheme != nil else {
                return ""
            }
            return enteredLink
        case "Event":
            return generateICSString()
        case "Wi-Fi":
            let ssid = enteredLink.trimmingCharacters(in: .whitespacesAndNewlines)
                .replacingOccurrences(of: ";", with: "\\;")
            let password = enteredMessage.trimmingCharacters(in: .whitespacesAndNewlines)
                .replacingOccurrences(of: ";", with: "\\;")
            let encryptionType: String

            switch wifiSelection {
            case .noEncryption:
                encryptionType = "nopass"
            case .wep:
                encryptionType = "WEP"
            case .wpa:
                encryptionType = "WPA"
            }

            return "WIFI:T:\(encryptionType);S:\(ssid);P:\(password);;"
        case "Text":
            let name = enteredName.replacingOccurrences(of: "%20", with: " ") 
            let link = enteredLink.replacingOccurrences(of: "%20", with: " ")
            return name.isEmpty ? link : "\(name)\n\(link)"
        case "Contact":
            let fullName = "\(enteredName) \(enteredLink)".trimmingCharacters(in: .whitespaces)
            let phoneNumber = enteredNumber.trimmingCharacters(in: .whitespacesAndNewlines)

            return """
            BEGIN:VCARD
            VERSION:3.0
            FN:\(fullName)
            TEL:\(phoneNumber)
            END:VCARD
            """
        case "Email":
            guard enteredName.contains("@") else { return "" }
            let subject = enteredLink.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let body = enteredMessage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return "mailto:\(enteredName)?subject=\(subject)&body=\(body)"
        case "Location":
            let name = enteredName.trimmingCharacters(in: .whitespacesAndNewlines)
            let details = enteredLocation.trimmingCharacters(in: .whitespacesAndNewlines)
            let coordinates = selectedLocation.map {
                "geo:\($0.placemark.coordinate.latitude),\($0.placemark.coordinate.longitude)"
            } ?? ""

            var qrString = coordinates
            if !name.isEmpty {
                qrString += "\n\(name)"
            }
            if !details.isEmpty {
                qrString += "\n\(details)"
            }
            return qrString

        case "Phone":
            let phoneNumber = enteredNumber.filter { $0.isNumber || $0 == "+" || $0.isWhitespace }
            return phoneNumber
        case "Crypto":
            let address = enteredName.trimmingCharacters(in: .whitespacesAndNewlines)
            let amount = enteredPassword.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !address.isEmpty else { return "" }

            var baseURL: String

            switch cryptoSelection {
            case .btc:
                baseURL = "https://www.blockchain.com/btc/address/"
            case .eth:
                baseURL = "https://etherscan.io/address/"
            case .trx:
                baseURL = "https://tronscan.org/#/address/"
            case .sol:
                baseURL = "https://explorer.solana.com/address/"
            }
            let amountQuery = amount.isEmpty ? "" : "?amount=\(amount)"
            return "\(baseURL)\(address)\(amountQuery)"
        case "General":
            if !enteredName.isEmpty && !enteredLink.isEmpty {
                return "\(enteredName)\n\(enteredLink)"
            } else if !enteredName.isEmpty {
                return enteredName
            } else if !enteredLink.isEmpty {
                return enteredLink
            } else {
                return ""
            }
        default:
            return ""
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color("PrimaryExtraLight")
                    .ignoresSafeArea(.all)
                VStack {
                    switch qrType.title {
                    case "Website":
                        websiteView
                    case "Text":
                        textView
                    case "Event":
                        eventView
                    case "Contact":
                        contactView
                    case "Email":
                        emailView
                    case "Location":
                        locationView
                    case "Wi-Fi":
                        wifiView
                    case "Phone":
                        phoneView
                    case "Crypto":
                        cryptoView
                    case "General":
                        generalView
                    default:
                        Text("Error")
                    }
                }
                
                .padding(.bottom, 10)
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
                        Text(qrType.title)
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(Color("PrimaryExtraDark"))
                    }
                }
                NavigationLink(destination: GeneratedView(startTime: startTime, endTime: endTime, name: enteredName, lastName: enteredLink, title: enteredName, link: generatedQRCodeString, text: enteredLink, number: enteredNumber, location: enteredLocation, encryption: wifiSelection.rawValue, address: enteredName, currency: cryptoSelection.rawValue, email: enteredName, subject: enteredLink, message: enteredMessage, amount: enteredPassword, codeColor: .white, backgroundColor: .black, qrImage: qrType.image, qrType: qrType, ssid: enteredLink, password: enteredMessage, onDismiss: {
                   isGenerating = false
                }), isActive: $isGenerating) {
                    Text("").hidden()
                }
                NavigationLink(destination: ContactsView(onSelectContact: updateContactInfo), isActive: $navigateToContactsView) {
                    Text("").hidden()
                }
            }
        }
    }
    
    //MARK: - Website View
    private var websiteView: some View {
        VStack(alignment: .leading) {
            Text("Enter Name")
            CustomTextField(title: "Type here...", enteredText: $enteredName, isText: $isEnterName)
                .padding(.bottom, 10)
            Text("Enter Link")
            CustomTextField(title: "Type here...", enteredText: $enteredLink, isText: $isEnterLink)
            Spacer()
            generateButton
        }
        .foregroundColor(Color("PrimaryExtraDark").opacity(0.5))
        .font(.system(size: 15, weight: .regular))
        .padding(.horizontal, 16)
    }
    
    //MARK: - Text View
    private var textView: some View {
        VStack(alignment: .leading) {
            Text("Name")
            CustomTextField(title: "Type here...", enteredText: $enteredName, isText: $isEnterName)
                .padding(.bottom, 10)
            Text("Enter Text")
            CustomTextField(title: "Type here...", enteredText: $enteredLink, isText: $isEnterLink)
            Spacer()
            generateButton
        }
        .foregroundColor(Color("PrimaryExtraDark").opacity(0.5))
        .font(.system(size: 15, weight: .regular))
        .padding(.horizontal, 16)
    }
    
    //MARK: - Event View
    private var eventView: some View {
        VStack(alignment: .leading) {
            Text("Enter Name")
            CustomTextField(title: "Type here...", enteredText: $enteredName, isText: $isEnterName)
                .padding(.bottom, 10)
            Text("Enter Location (Optional)")
            CustomTextField(title: "Type here...", enteredText: $enteredLocation, isText: $isEnterLink)
                .padding(.bottom, 10)
            Text("Event Time")
            DatePicker("Start Time", selection: $startTime)
                .datePickerStyle(CompactDatePickerStyle())
                .padding(12)
                .background(Color("White"))
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color("PrimaryLight"), lineWidth: 1))
                .cornerRadius(16)
            DatePicker("End Time", selection: $endTime)
                .datePickerStyle(CompactDatePickerStyle())
                .padding(12)
                .background(Color("White"))
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color("PrimaryLight"), lineWidth: 1))
                .cornerRadius(16)
            Spacer()
            generateButton
        }
        .foregroundColor(Color("PrimaryExtraDark").opacity(0.5))
        .font(.system(size: 15, weight: .regular))
        .padding(.horizontal, 16)
    }
    
    //MARK: - Contacts View
    private var contactView: some View {
        VStack(alignment: .leading) {
            Text("First Name")
            CustomTextField(title: "Type here...", enteredText: $enteredName, isText: $isEnterName)
                .padding(.bottom, 10)
            Text("Phone Number")
            CustomTextField(title: "Type here...", enteredText: $enteredNumber, isText: $isEnterLink)
                .padding(.bottom, 5)
                Button {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    navigateToContactsView = true
                } label: {
                    Text("Fill From Contacts")
                        .font(.system(size: 19, weight: .medium))
                        .foregroundColor(Color("Primary"))
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 16)
                .background(Color("White"))
                .cornerRadius(24)
            Spacer()
            generateButton
        }
        .foregroundColor(Color("PrimaryExtraDark").opacity(0.5))
        .font(.system(size: 15, weight: .regular))
        .padding(.horizontal, 16)
    }
    
    //MARK: - Email View
    private var emailView: some View {
        VStack(alignment: .leading) {
            Text("Email Address")
            CustomTextField(title: "Type here...", enteredText: $enteredName, isText: $isEnterName)
                .padding(.bottom, 10)
            Text("Subject (Optional)")
            CustomTextField(title: "Type here...", enteredText: $enteredLink, isText: $isEnterLink)
                .padding(.bottom, 10)
            Text("Message (Optional)")
            CustomTextField(title: "Type here...", enteredText: $enteredMessage, isText: $isEnterMessage)
            
            Spacer()
            generateButton
        }
        .foregroundColor(Color("PrimaryExtraDark").opacity(0.5))
        .font(.system(size: 15, weight: .regular))
        .padding(.horizontal, 16)
    }
    
    //MARK: - Location View
    private var locationView: some View {
        VStack(alignment: .leading) {
            Text("Enter Name")
            CustomTextField(title: "Type here...", enteredText: $enteredName, isText: $isEnterName)
                .padding(.bottom, 10)
            Text("Search Address")
            SearchLocationField(searchText: $enteredLocation, isSearching: $isSearch, onClear: {
                selectedLocation = nil 
            })
                .onChange(of: enteredLocation) { newValue in
                    if !newValue.isEmpty {
                        locationViewModel.searchLocation(query: newValue)
                    }
                }
            if let selectedLocation = selectedLocation {
                MapView(location: selectedLocation)
                    .frame(height: 300)
                    .cornerRadius(12)
            } else {
                VStack {
                    ScrollView(showsIndicators: false) {
                        ForEach(locationViewModel.searchResults, id: \.self) { location in
                            LocationCard(location: location) {
                                selectedLocation = location
                                enteredLocation = location.name ?? "Unknown Location"
                            }
                        }
                    }
                }
            }
            
            if enteredLocation.isEmpty {
                
            } else {
                
            }
            Spacer()
            generateButton
        }
        .foregroundColor(Color("PrimaryExtraDark").opacity(0.5))
        .font(.system(size: 15, weight: .regular))
        .padding(.horizontal, 16)
    }
    
    //MARK: - Wifi View
    private var wifiView: some View {
        VStack(alignment: .leading) {
            Text("Enter Name")
            CustomTextField(title: "Type here...", enteredText: $enteredName, isText: $isEnterName)
                .padding(.bottom, 10)
            Text("Wireless")
            CustomTextField(title: "Name (SSID)",  enteredText: $enteredLink, isText: $isEnterLink)
            CustomTextField(title: "Password", enteredText: $enteredMessage, isText: $isEnterMessage)
                .padding(.bottom, 10)
            Text("Encryption")
            Picker("", selection: $wifiSelection) {
                ForEach(WifiSelection.allCases, id: \.self) { selection in
                    Text(selection.rawValue)
                        .font(.system(size: 15, weight: .regular))
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .tint(Color("White"))
            Spacer()
            generateButton
        }
        .foregroundColor(Color("PrimaryExtraDark").opacity(0.5))
        .font(.system(size: 15, weight: .regular))
        .padding(.horizontal, 16)
    }
    
    //MARK: - Phone View
    private var phoneView: some View {
        VStack(alignment: .leading) {
            Text("Phote Number")
            CustomTextField(title: "Type here...", enteredText: $enteredNumber, isText: $isEnterLink)
                .padding(.bottom, 5)
            Button {
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
                navigateToContactsView = true
            } label: {
                Text("Fill From Contacts")
                    .font(.system(size: 19, weight: .medium))
                
                    .foregroundColor(Color("Primary"))
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 16)
            .background(Color("White"))
            .cornerRadius(24)
            
            Spacer()
            generateButton
        }
        .foregroundColor(Color("PrimaryExtraDark").opacity(0.5))
        .font(.system(size: 15, weight: .regular))
        .padding(.horizontal, 16)
    }
    
    //MARK: - Crypto View
    private var cryptoView: some View {
        VStack(alignment: .leading) {
            Text("Cryptocurrency")            
            Picker("Select Cryptocurrency", selection: $cryptoSelection) {
                ForEach(CryptoSelection.allCases, id: \.self) {
                    Text($0.rawValue)
                        .font(.system(size: 15, weight: .regular))
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.bottom, 10)
            Text("Wallet Address")
            CustomTextField(title: "Enter wallet address...", enteredText: $enteredName, isText: $isEnterName)
                .padding(.bottom, 10)
            Text("Amount")
            CustomTextField(title: "Enter amount...", enteredText: $enteredPassword, isText: $isEnterMessage)
                .padding(.bottom, 10)
            Spacer()
            
            Button {
                if isFormValid {
                    isGenerating = true
                }
            } label: {
                HStack(spacing: 12) {
                    Image("qrTrue")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 25, height: 25)
                    Text("Generate")
                        .font(.system(size: 19, weight: .medium))
                }
                .foregroundColor(Color("White"))
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(Color("Primary"))
                .cornerRadius(24)
                .opacity(isFormValid ? 1.0 : 0.5)
            }
            .disabled(!isFormValid)
        }
        .foregroundColor(Color("PrimaryExtraDark").opacity(0.5))
        .font(.system(size: 15, weight: .regular))
        .padding(.horizontal, 16)
    }

    //MARK: - General View
    private var generalView: some View {
        VStack(alignment: .leading) {
            Text("Name")
            CustomTextField(title: "Type here...", enteredText: $enteredName, isText: $isEnterName)
                .padding(.bottom, 10)
            Text("Enter Text")
            CustomTextField(title: "Paste text or link", enteredText: $enteredLink, isText: $isEnterLink)
            Spacer()
            generateButton
        }
        .foregroundColor(Color("PrimaryExtraDark").opacity(0.5))
        .font(.system(size: 15, weight: .regular))
        .padding(.horizontal, 16)
    }

    
    //MARK: - Generate Button
    private var generateButton: some View {
        Button {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            
            if isFormValid {
                isGenerating = true
            }
        } label: {
            HStack(spacing: 12) {
                Image("qrTrue")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 25, height: 25)
                Text("Generate")
                    .font(.system(size: 19, weight: .medium))
            }
            .foregroundColor(Color("White"))
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(Color("Primary"))
            .cornerRadius(24)
            .opacity(isFormValid ? 1.0 : 0.5)
        }
        .disabled(!isFormValid)
    }
    
    //MARK: - Update Contact info
    func updateContactInfo(givenName: String, familyName: String, phoneNumber: String) {
        enteredName = givenName
        enteredLink = familyName
        enteredNumber = phoneNumber
    }
    
    private func generateICSString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let formattedStart = formatter.string(from: startTime)
        let formattedEnd = formatter.string(from: endTime)
        
        return """
        BEGIN:VCALENDAR
        VERSION:2.0
        BEGIN:VEVENT
        SUMMARY:\(enteredName)
        LOCATION:\(enteredLocation)
        DTSTART:\(formattedStart)
        DTEND:\(formattedEnd)
        DESCRIPTION:\(enteredMessage)
        END:VEVENT
        END:VCALENDAR
        """
    }
}

