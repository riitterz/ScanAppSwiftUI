//
//  GeneratedView.swift
//  ScanAppSwiftUI
//
//  Created by Macbook on 05/11/2024.
//

import SwiftUI

struct GeneratedView: View {
    @EnvironmentObject var qrCodeStorage: QRCodeStorage
    @State var startTime = Date()
    @State var endTime = Date()
    @State var name: String
    @State var lastName: String
    @State var title: String
    @State var link: String
    @State var text: String
    @State var number: String
    @State var location: String
    @State var encryption: String
    @State var address: String
    @State var currency: String
    @State var email: String
    @State var subject: String
    @State var message: String
    @State var amount: String
    @State var isSaved = false
    @State var codeColor: UIColor
    @State var backgroundColor: UIColor
    var qrImage: String

    var isFromHistory: Bool = false
    @State private var showSuccessMessage = true
    @State private var showEditColorView: Bool = false
    @State private var showSaveMessage: Bool = false
    let qrType: QRType
    var isFromImagePicker: Bool = false
    @State var ssid: String
    @State var password: String
    var onDismiss: () -> Void
    @State private var showEmailAlert = false

    var body: some View {
        NavigationView {
            ZStack {
                Color("PrimaryExtraLight")
                    .ignoresSafeArea(.all)
                VStack {
                    ScrollView(showsIndicators: false) {
                        VStack {
                            ZStack(alignment: .top) {
                                QRCodeGenerate(url: link, codeColor: codeColor, backgroundColor: backgroundColor)
                                    .frame(width: 256, height: 256)

                                if showSaveMessage {
                                    HStack {
                                        Image(systemName: "checkmark.circle.fill")
                                        Text("\(qrType.title) saved to Photos successfully")
                                            .font(.system(size: 17, weight: .medium))
                                        Spacer()
                                        Image(systemName: "xmark")
                                            .onTapGesture {
                                                showSaveMessage = false
                                            }
                                    }
                                    .foregroundColor(Color("White"))
                                    .padding(16)
                                    .background(Color.green)
                                    .cornerRadius(16)
                                }

                                if showSuccessMessage && isSaved {
                                    HStack {
                                        Image(systemName: "checkmark.circle.fill")
                                        Text("\(qrType.title) created successfully")
                                            .font(.system(size: 17, weight: .medium))
                                        Spacer()
                                        Image(systemName: "xmark")
                                            .onTapGesture {
                                                showSuccessMessage = false
                                            }
                                    }
                                    .foregroundColor(Color("White"))
                                    .padding(16)
                                    .background(Color.green)
                                    .cornerRadius(16)
                                }
                            }
                        }
                        if isFromImagePicker || isFromHistory {
                            dynamicScanned(for: qrType)
                                .foregroundColor(Color("PrimaryExtraDark").opacity(0.5))
                                .font(.system(size: 15, weight: .regular))
                                .frame(maxWidth: .infinity)
                                .padding(.top, 20)
                        } else {
                            dynamicView(for: qrType)
                                .foregroundColor(Color("PrimaryExtraDark").opacity(0.5))
                                .font(.system(size: 15, weight: .regular))
                                .frame(maxWidth: .infinity)
                                .padding(.top, 20)
                        }

                    }
                    .statusBarHidden(true)
                    Spacer()

                    VStack {
                        HStack {
                            ActionButton(image: "save") {
                                withAnimation {
                                    showSuccessMessage = false
                                    showSaveMessage = true
                                }
                                let qrCodeView = QRCodeGenerate(url: link, codeColor: codeColor, backgroundColor: backgroundColor)
                                    .frame(width: 1000, height: 1000)
                                downloadQRCode(qrCodeView: qrCodeView)
                            }
                            ActionButton(image: "actionShare") {
                                let qrCodeView = QRCodeGenerate(url: link, codeColor: codeColor, backgroundColor: backgroundColor)
                                    .frame(width: 1000, height: 1000)
                                shareQRCodeView(qrCodeView: qrCodeView)
                            }
                            ActionButton(image: "color") {
                                showEditColorView.toggle()
                            }
                        }
                        if !isFromHistory {
                            Button {
                                let generator = UIImpactFeedbackGenerator(style: .medium)
                                generator.impactOccurred()
                                saveQRCode()
                                withAnimation {
                                    showSaveMessage = false
                                    showSuccessMessage = true
                                    isSaved = true
                                }
                            } label: {
                                Text("Save")
                                    .font(.system(size: 19, weight: .medium))
                                    .foregroundColor(Color("White"))
                                    .padding(.vertical, 16)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .background(Color("Primary"))
                                    .cornerRadius(24)
                            }
                            .disabled(isSaved)
                        } else {

                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 10)
                .navigationBarBackButtonHidden(true)
                .frame(maxHeight: .infinity)
                .padding(.top, -20)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            onDismiss()
                        } label: {
                            Image("back")
                        }
                    }
                    ToolbarItem(placement: .principal) {
                        Text(qrType.title)
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(Color("PrimaryExtraDark"))
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if isFromHistory {
                            Button {
                                let generator = UIImpactFeedbackGenerator(style: .medium)
                                generator.impactOccurred()
                                deleteQRCode()
                            } label: {
                                Image("delete")
                            }

                        } else {

                        }
                    }
            }
                if showEditColorView {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea(.all)
                        .transition(.opacity)
                        .onTapGesture {
                            withAnimation {
                                showEditColorView = false
                            }
                        }
                        .zIndex(2)
                    EditColorView(showEditColorView: $showEditColorView, codeColor: $codeColor, backgroundColor: $backgroundColor)
                        .zIndex(3)
                        .transition(.move(edge: .bottom))
                }
            }
            .alert(isPresented: $showEmailAlert) {
                Alert(
                    title: Text("Mail App Unavailable"),
                    message: Text("Please configure your Mail app to use this feature."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .onAppear {
                loadQRCodeDataIfNeeded()
                
            }
            .onDisappear {
                updateQRCodeInHistory()
        }
        }
        .navigationBarBackButtonHidden(true)

    }
    
    @ViewBuilder
    private func dynamicScanned(for qrType: QRType) -> some View {
        switch qrType.title {
        case "Website":
            VStack(alignment: .leading) {
                if !name.isEmpty {
                    Text("Name")
                    CreatedField(title: name, isScanned: true)
                }
                Text("Link")
                CreatedField(title: link, isScanned: true)
                if isFromImagePicker {
                    Button {
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                        openInBrowser(urlString: link)
                    } label: {
                        ConnectionButton(image: "openBrowser", title: "Open in Browser")
                    }
                }
            }
        case "Text":
            VStack(alignment: .leading) {
                if !name.isEmpty {
                    Text("Name")
                    CreatedField(title: name, isScanned: true)
                        .padding(.bottom, 10)
                }
                if !text.isEmpty {
                    Text("Text")
                    CreatedField(title: text, isScanned: true)
                }
                if isFromImagePicker {
                    Button {
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                        let search = "\(name) \(text)"
                        searchInBrowser(query: search)
                    } label: {
                        ConnectionButton(image: "openBrowser", title: "Search in Browser")
                    }
                }
            }
        case "Event":
            VStack(alignment: .leading) {
                Text("Name")
                CreatedField(title: name, isScanned: true)
                    .padding(.bottom, 10)
                if !location.isEmpty {
                    Text("Location")
                    CreatedField(title: location, isScanned: true)
                        .padding(.bottom, 10)
                }
                Text("Event Time")
                VStack(spacing: 8) {
                    DatePicker("Start Time", selection: $startTime, displayedComponents: [.date, .hourAndMinute])
                        .disabled(true)
                        .datePickerStyle(CompactDatePickerStyle())
                        .padding()
                        .background(Color("White"))
                        .cornerRadius(16)
                    
                    DatePicker("End Time", selection: $endTime, displayedComponents: [.date, .hourAndMinute])
                        .disabled(true)
                        .datePickerStyle(CompactDatePickerStyle())
                        .padding()
                        .background(Color("White"))
                        .cornerRadius(16)
                }
                if isFromImagePicker {
                    Button {
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                        addToCalendar(name: name, location: location, startDate: startTime, endDate: endTime)
                    } label: {
                        ConnectionButton(image: "openCalendar", title: "Add to Calendar")
                    }
                }
            }
        case "Contact":
            VStack(alignment: .leading) {
                Text("Name")
                CreatedField(title: name, isScanned: true)
                    .padding(.bottom, 10)
                if !lastName.isEmpty {
                    Text("Last Name")
                    CreatedField(title: lastName, isScanned: true)
                        .padding(.bottom, 10)
                }
                Text("Phone Number")
                CreatedField(title: number, isScanned: true)
                if isFromImagePicker {
                    Button {
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                        saveToContacts(firstName: name, familyName: lastName, phoneNumber: number)
                    } label: {
                        ConnectionButton(image: "openContact", title: "Open Contact")
                    }
                }
            }
        case "Email":
            VStack(alignment: .leading) {
                Text("Email Address")
                CreatedField(title: email, isScanned: true)
                    .padding(.bottom, 10)
                if !subject.isEmpty {
                    Text("Subject")
                    CreatedField(title: subject, isScanned: true)
                        .padding(.bottom, 10)
                }
                if !message.isEmpty {
                    Text("Message")
                    CreatedField(title: message, isScanned: true)
                }
                if isFromImagePicker {
                    Button {
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                       createEmail(email: email, subject: subject, message: message)
                    } label: {
                        ConnectionButton(image: "createEmail", title: "Create an Email")
                    }
                }
            }
        case "Location":
            VStack(alignment: .leading) {
                Text("Enter Name")
                CreatedField(title: name, isScanned: true)
                    .padding(.bottom, 10)
                Text("Search Address")
                CreatedField(title: location, isScanned: true)
                if isFromImagePicker {
                    Button {
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                        openInMap(location: location)
                    } label: {
                        ConnectionButton(image: "openMap", title: "Open on Map")
                    }
                }
            }
        case "Wi-Fi":
            VStack(alignment: .leading) {
                if !name.isEmpty {
                    Text("Name")
                    CreatedField(title: name, isScanned: true)
                        .padding(.bottom, 10)
                }
                Text("Wireless")
                CreatedField(title: ssid, isScanned: true)
                CreatedField(title: password, isScanned: true)
                    .padding(.bottom, 10)
                Text("Encryption")
                CreatedField(title: encryption, isScanned: true)
                if isFromImagePicker {
                    Button {
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                        connectToWiFi(ssid: ssid, password: password, encryption: encryption)
                    } label: {
                        ConnectionButton(image: "connectNetwork", title: "Join Network")
                    }
                }
            }
        case "Phone":
            VStack(alignment: .leading) {
                Text("Phone Number")
                CreatedField(title: number, isScanned: true)
                if isFromImagePicker {
                    Button {
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                        openContact(number: number)
                    } label: {
                        ConnectionButton(image: "openNumber", title: "Open Contact")
                    }
                }
            }
        case "Crypto":
            VStack(alignment: .leading) {
                Text("Cryptocurrency")
                CreatedField(title: currency, isScanned: true)
                    .padding(.bottom, 10)
                Text("Address")
                CreatedField(title: address, isScanned: true)
                    .padding(.bottom, 10)
                if !amount.isEmpty {
                    Text("Amount")
                    CreatedField(title: amount, isScanned: true)
                }
                if isFromImagePicker {
                    Button {
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                        openInBrowser(urlString: link)
                    } label: {
                        ConnectionButton(image: "openBrowser", title: "Open in Browser")
                    }
                }
            }
        case "General":
            VStack(alignment: .leading) {
                Text("Name")
                CreatedField(title: name, isScanned: true)
                    .padding(.bottom, 10)
                Text("Text")
                CreatedField(title: text, isScanned: true)
                if isFromImagePicker {
                    Button {
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                        let search = "\(name) \(text)"
                        searchInBrowser(query: search)
                    } label: {
                        ConnectionButton(image: "openBrowser", title: "Open in Browser")
                    }
                }
            }
        default:
            Text("Error")
        }
    }

    @ViewBuilder
    private func dynamicView(for qrType: QRType) -> some View {
        switch qrType.title {
        case "Website":
            VStack(alignment: .leading) {
                Text("Name")
                CreatedField(title: name, isScanned: false)
                    .padding(.bottom, 10)
                Text("Link")
                CreatedField(title: link, isScanned: false)
            }
        case "Text":
            VStack(alignment: .leading) {
                Text("Name")
                CreatedField(title: name, isScanned: false)
                    .padding(.bottom, 10)
                Text("Text")
                CreatedField(title: text, isScanned: false)
            }
        case "Event":
            VStack(alignment: .leading, spacing: 16) {
                Text("Name")
                CreatedField(title: name, isScanned: false)
                if !location.isEmpty {
                    Text("Location")
                    CreatedField(title: location, isScanned: false)
                        .padding(.bottom, 10)
                }
                Text("Event Time")
                VStack(spacing: 8) {
                    DatePicker("Start Time", selection: .constant(startTime))
                        .disabled(true)
                        .datePickerStyle(CompactDatePickerStyle())
                        .padding()
                        .background(Color("White"))
                        .cornerRadius(16)
                    
                    DatePicker("End Time", selection: .constant(endTime))
                        .disabled(true)
                        .datePickerStyle(CompactDatePickerStyle())
                        .padding()
                        .background(Color("White"))
                        .cornerRadius(16)
                }
            }
        case "Contact":
            VStack(alignment: .leading) {
                Text("Name")
                CreatedField(title: name, isScanned: false)
                    .padding(.bottom, 10)
                if !lastName.isEmpty {
                    Text("Last Name")
                    CreatedField(title: lastName, isScanned: false)
                        .padding(.bottom, 10)
                }
                Text("Phone Number")
                CreatedField(title: number, isScanned: false)
            }
        case "Email":
            VStack(alignment: .leading) {
                Text("Email Address")
                CreatedField(title: email, isScanned: false)
                    .padding(.bottom, 10)
                if !subject.isEmpty {
                    Text("Subject")
                    CreatedField(title: subject, isScanned: false)
                        .padding(.bottom, 10)
                }
                if !message.isEmpty {
                    Text("Message")
                    CreatedField(title: message, isScanned: false)
                }
            }
        case "Location":
            VStack(alignment: .leading) {
                Text("Enter Name")
                CreatedField(title: name, isScanned: false)
                    .padding(.bottom, 10)
                Text("Search Address")
                CreatedField(title: location, isScanned: false)
            }
        case "Wi-Fi":
            VStack(alignment: .leading) {
                Text("Name")
                CreatedField(title: name, isScanned: false)
                    .padding(.bottom, 10)
                Text("Wireless")
                CreatedField(title: ssid, isScanned: false)
                CreatedField(title: password, isScanned: false)
                    .padding(.bottom, 10)
                Text("Encryption")
                CreatedField(title: encryption, isScanned: false)
            }
        case "Phone":
            VStack(alignment: .leading) {
                Text("Phone Number")
                CreatedField(title: number, isScanned: false)
            }
        case "Crypto":
            VStack(alignment: .leading) {
                Text("Cryptocurrency")
                CreatedField(title: currency, isScanned: false)
                    .padding(.bottom, 10)
                Text("Address")
                CreatedField(title: address, isScanned: false)
                    .padding(.bottom, 10)
                Text("Amount")
                CreatedField(title: amount, isScanned: false)
            }
        case "General":
            VStack(alignment: .leading) {
                Text("Name")
                CreatedField(title: name, isScanned: false)
                    .padding(.bottom, 10)
                Text("Text")
                CreatedField(title: text, isScanned: false)
            }
        default:
            Text("Error")
        }
    }
    
    private func saveQRCode() {
        let newQRCode = QRCard(
            qrString: link,
            startTime: startTime,
            endTime: endTime,
            name: name,
            lastName: lastName,
            title: title,
            link: link,
            text: text,
            number: number,
            location: location,
            encryption: encryption,
            address: address,
            currency: currency,
            email: email,
            subject: subject,
            message: message,
            amount: amount,
            codeColor: codeColor,
            backgroundColor: backgroundColor,
            image: qrImage,
            qrType: qrType,
            ssid: ssid,
            password: password
        )
        if isFromImagePicker {
            qrCodeStorage.imagePickerQRCodes.insert(newQRCode, at: 0)
        } else {
            qrCodeStorage.savedQRCodes.insert(newQRCode, at: 0) 
        }
    }
    
    private func deleteQRCode() {
        if let index = qrCodeStorage.savedQRCodes.firstIndex(where: { $0.qrString == link })  {
            qrCodeStorage.savedQRCodes.remove(at: index)
        } else if let index = qrCodeStorage.imagePickerQRCodes.firstIndex(where: { $0.qrString == link }) {
            qrCodeStorage.imagePickerQRCodes.remove(at: index)
        }
        
        onDismiss()
    }
    
    func shareQRCodeView<T: View>(qrCodeView: T) {
        let qrCodeImage = ViewToImage(content: { AnyView(qrCodeView) }).toUIImage()
        
        let activityController = UIActivityViewController(activityItems: [qrCodeImage], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            
            var topController = rootViewController
            while let presentedController = topController.presentedViewController {
                topController = presentedController
            }
            
            topController.present(activityController, animated: true, completion: nil)
        }
    }
    
    private func loadQRCodeDataIfNeeded() {
        if isFromHistory {
            if let qrCode = qrCodeStorage.savedQRCodes.first(where: { $0.qrString == link }) {
                startTime = qrCode.startTime
                endTime = qrCode.endTime
                name = qrCode.name
                lastName = qrCode.lastName
                title = qrCode.title
                link = qrCode.link
                text = qrCode.text
                number = qrCode.number
                location = qrCode.location
                encryption = qrCode.encryption
                address = qrCode.address
                currency = qrCode.currency
                email = qrCode.email
                subject = qrCode.subject
                message = qrCode.message
                amount = qrCode.amount
                codeColor = qrCode.codeColor
                backgroundColor = qrCode.backgroundColor
            }
        }
    }

    private func updateQRCodeInHistory() {
        if isFromHistory {
            let updatedQRCode = QRCard(qrString: link, startTime: startTime, endTime: endTime, name: name, lastName: lastName, title: title, link: link, text: text, number: number, location: location, encryption: encryption, address: address, currency: currency, email: email, subject: subject, message: message, amount: amount, codeColor: codeColor, backgroundColor: backgroundColor, image: qrImage, qrType: qrType, ssid: ssid, password: password)
            qrCodeStorage.updateQRCode(updatedQRCode)
        }
    }
    private func openInBrowser(urlString: String) {
        var processedURLString = urlString

        if urlString.range(of: #"^(1|3|bc1)[a-zA-HJ-NP-Z0-9]{25,42}$"#, options: .regularExpression) != nil {
            processedURLString = "https://blockchain.com/btc/address/\(urlString)"
        } else if urlString.range(of: #"^0x[a-fA-F0-9]{40}$"#, options: .regularExpression) != nil {
            processedURLString = "https://etherscan.io/address/\(urlString)"
        } else if urlString.range(of: #"^[a-zA-Z0-9]{43,44}$"#, options: .regularExpression) != nil {
            processedURLString = "https://explorer.solana.com/address/\(urlString)"
        } else if urlString.range(of: #"^T[a-zA-Z0-9]{33}$"#, options: .regularExpression) != nil {
            processedURLString = "https://tronscan.org/#/address/\(urlString)"
        } else if !urlString.starts(with: "http://") && !urlString.starts(with: "https://") {
            processedURLString = "https://\(urlString)"
        }

        guard let url = URL(string: processedURLString), UIApplication.shared.canOpenURL(url) else {
            print("Error: Invalid URL - \(processedURLString)")
            return
        }

        UIApplication.shared.open(url)
    }

    private func searchInBrowser(query: String) {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let searchURL = "https://www.google.com/search?q=\(encodedQuery)"
        openInBrowser(urlString: searchURL)
    }
    
    private func createEmail(email: String, subject: String, message: String) {
        let emailString = "mailto:\(email)?subject=\(subject)&body=\(message)"
        guard let emailURL = URL(string: emailString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            print("Invalid mailto URL")
            return
        }

        if UIApplication.shared.canOpenURL(emailURL) {
            UIApplication.shared.open(emailURL, options: [:]) { success in
                if success {
                    print("Mail app opened successfully")
                } else {
                    print("Failed to open Mail app")
                }
            }
        } else {
            print("Cannot open mailto URL")
        }
    }
    
    private func openInMap(location: String) {
        let encodedLocation = location.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let mapURL = "https://maps.apple.com/?q=\(encodedLocation)"
        openInBrowser(urlString: mapURL)
    }
}


