//
//  ScanView.swift
//  ScanAppSwiftUI
//
//  Created by Macbook on 27/10/2024.
//

import SwiftUI
import AVKit
import CoreImage.CIFilterBuiltins

struct ScanView: View {
    @StateObject private var qrDelegate = QRScannerDelegate()
    @State private var session: AVCaptureSession = .init()
    @State private var qrOutput: AVCaptureMetadataOutput = .init()
    @State private var cameraPermission: Permission = .idle
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    @State private var showImagePicker = false
    @State private var isFlashOn = false
    @State private var isSettingsPresentable = false
    @State private var selectedQRCard: QRCard? = nil
    @Environment(\.openURL) private var openURL

    var body: some View {
        NavigationView {
            ZStack {
                Color("PrimaryExtraLight")
                    .ignoresSafeArea(.all)
                VStack {
                    Text("Align your camera with the QR code to begin scanning.")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 19, weight: .medium))
                        .foregroundColor(Color("PrimaryExtraDark").opacity(0.5))

                    GeometryReader {
                        let size = $0.size

                        ZStack(alignment: .top) {
                            RoundedRectangle(cornerRadius: 64)
                            CameraView(frameSize: size, session: $session)
                                .cornerRadius(64)
                            VStack {
                                Image("scanArea")
                                    .resizable()
                                    .padding(.bottom, 32)
                                HStack {
                                    Button {
                                        showImagePicker = true
                                    } label: {
                                        Image("photo")
                                            .padding(16)
                                            .background(Color("White"))
                                            .cornerRadius(100)
                                    }
                                    Spacer()
                                    Button {
                                        toggleFlashlight()
                                    } label: {
                                        Image(isFlashOn ? "flashOn" : "flashOff")
                                            .padding(16)
                                            .background(Color("White"))
                                            .cornerRadius(100)
                                    }
                                }
                            }
                            .padding(32)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 80)
                .padding(.top, -20)
            }
            .onAppear(perform: checkCameraPermission)
            .alert(errorMessage, isPresented: $showError) {
                if cameraPermission == .denied {
                    Button("Settings") {
                        let settingsString = UIApplication.openSettingsURLString
                        if let settingsUrl = URL(string: settingsString) {
                            openURL(settingsUrl)
                        }
                    }

                    Button("Cancel", role: .cancel) {

                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {

                    } label: {
                        Image("pro")
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("Scan QR")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(Color("PrimaryExtraDark"))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image("settings")
                        .onTapGesture {
                            isSettingsPresentable = true
                        }
                    .fullScreenCover(isPresented: $isSettingsPresentable) {
                        SettingsView()
                    }
                }
            }

            .sheet(isPresented: $showImagePicker) {
                ImagePicker(isPresented: $showImagePicker) { image in
                    processImage(image)
                }
            }
            .fullScreenCover(item: $selectedQRCard) { qrCard in

                GeneratedView(startTime: qrCard.startTime, endTime: qrCard.endTime, name: qrCard.name, lastName: qrCard.lastName, title: qrCard.title, link: qrCard.qrString, text: qrCard.text, number: qrCard.number, location: qrCard.location, encryption: qrCard.encryption, address: qrCard.address, currency: qrCard.currency, email: qrCard.email, subject: qrCard.subject, message: qrCard.message, amount: qrCard.amount, codeColor: qrCard.codeColor, backgroundColor: qrCard.backgroundColor, qrImage: qrCard.image, qrType: qrCard.qrType, isFromImagePicker: true, ssid: qrCard.ssid, password: qrCard.password) {
                        selectedQRCard = nil
                    }
            }
        }
    }
    
    private func handleQRDetection(_ qrString: String) {
        session.stopRunning()
        let qrType = detectQRType(from: qrString)
        selectedQRCard = processQRCode(qrString, qrType: qrType)
    }

    private func processQRCode(_ content: String, qrType: QRType) -> QRCard {
        switch qrType.title {
        case "Wi-Fi":
            let wifiDetails = parseWifiQRCode(content)
            return QRCard(
                qrString: content,
                startTime: Date(),
                endTime: Date(),
                name: "",
                lastName: "",
                title: qrType.title,
                link: content,
                text: "",
                number: "",
                location: "",
                encryption: wifiDetails.encryption,
                address: "",
                currency: "",
                email: "",
                subject: "",
                message: "",
                amount: "",
                codeColor: .white,
                backgroundColor: .black,
                image: qrType.image,
                qrType: qrType,
                ssid: wifiDetails.ssid,
                password: wifiDetails.password
            )
        case "Event":
            let eventDetails = parseEventQRCode(content)
            return QRCard(
                qrString: content,
                startTime: eventDetails.startDate ?? Date(),
                endTime: eventDetails.endDate ?? Date(),
                name: eventDetails.summary,
                lastName: "",
                title: qrType.title,
                link: content,
                text: eventDetails.description,
                number: "",
                location: eventDetails.location,
                encryption: "",
                address: eventDetails.location,
                currency: "",
                email: "",
                subject: "",
                message: "",
                amount: "",
                codeColor: .white,
                backgroundColor: .black,
                image: qrType.image,
                qrType: qrType,
                ssid: "",
                password: ""
            )
        case "Contact":
            let contactDetails = parseContactQRCode(content)
            return QRCard(
                qrString: content,
                startTime: Date(),
                endTime: Date(),
                name: contactDetails.name,
                lastName: contactDetails.lastName,
                title: qrType.title,
                link: "",
                text: "",
                number: contactDetails.number,
                location: "",
                encryption: "",
                address: "",
                currency: "",
                email: "",
                subject: "",
                message: "",
                amount: "",
                codeColor: .white,
                backgroundColor: .black,
                image: qrType.image,
                qrType: qrType,
                ssid: "",
                password: ""
            )
        case "Email":
            let emailDetails = parseEmailQRCode(content)
            return QRCard(
                qrString: content,
                startTime: Date(),
                endTime: Date(),
                name: "",
                lastName: "",
                title: qrType.title,
                link: "",
                text: "",
                number: "",
                location: "",
                encryption: "",
                address: "",
                currency: "",
                email: emailDetails.email,
                subject: emailDetails.subject,
                message: emailDetails.message,
                amount: "",
                codeColor: .white,
                backgroundColor: .black,
                image: qrType.image,
                qrType: qrType,
                ssid: "",
                password: ""
            )
        case "Crypto":
            let cryptoDetails = parseCryptoQRCode(content)
            return QRCard(
                qrString: content,
                startTime: Date(),
                endTime: Date(),
                name: cryptoDetails.name,
                lastName: "",
                title: qrType.title,
                link: "",
                text: "",
                number: "",
                location: "",
                encryption: "",
                address: cryptoDetails.address,
                currency: cryptoDetails.name,
                email: "",
                subject: "",
                message: "",
                amount: cryptoDetails.amount,
                codeColor: .white,
                backgroundColor: .black,
                image: qrType.image,
                qrType: qrType,
                ssid: "",
                password: ""
            )
        case "Location":
            let locationDetails = parseLocationQRCode(content)
            return QRCard(
                qrString: content,
                startTime: Date(),
                endTime: Date(),
                name: locationDetails.name,
                lastName: "",
                title: qrType.title,
                link: "",
                text: locationDetails.location,
                number: "",
                location: locationDetails.location,
                encryption: "",
                address: "",
                currency: "",
                email: "",
                subject: "",
                message: "",
                amount: "",
                codeColor: .white,
                backgroundColor: .black,
                image: qrType.image,
                qrType: qrType,
                ssid: "",
                password: ""
            )
        case "General":
            let generalDetails = parseGeneralQRCode(content)
            return QRCard(
                qrString: content,
                startTime: Date(),
                endTime: Date(),
                name: generalDetails.name,
                lastName: "",
                title: qrType.title,
                link: generalDetails.content,
                text: generalDetails.content,
                number: "",
                location: "",
                encryption: "",
                address: "",
                currency: "",
                email: "",
                subject: "",
                message: "",
                amount: "",
                codeColor: .white,
                backgroundColor: .black,
                image: qrType.image,
                qrType: qrType,
                ssid: "",
                password: ""
            )
        default:
            return QRCard(
                qrString: content,
                startTime: Date(),
                endTime: Date(),
                name: "",
                lastName: "",
                title: qrType.title,
                link: content,
                text: "",
                number: "",
                location: "",
                encryption: "",
                address: "",
                currency: "",
                email: "",
                subject: "",
                message: "",
                amount: "",
                codeColor: .white,
                backgroundColor: .black,
                image: qrType.image,
                qrType: qrType,
                ssid: "",
                password: ""
            )
        }
    }

    private func generateQRCard(from qrString: String, type: QRType) -> QRCard {
        return QRCard(
            qrString: qrString,
            startTime: Date(),
            endTime: Date(),
            name: "",
            lastName: "",
            title: type.title,
            link: qrString,
            text: "",
            number: "",
            location: "",
            encryption: "",
            address: "",
            currency: "",
            email: "",
            subject: "",
            message: "",
            amount: "",
            codeColor: .white,
            backgroundColor: .black,
                image: type.image,
            qrType: type,
            ssid: "",
            password: ""
        )
    }
    
    private func processImage(_ image: UIImage?) {
        guard let image = image else {
            presentError("Failed to load the image.")
            return
        }

        if let scannedResult = scanQRCode(from: image) {
            let (content, type) = scannedResult
            print("DEBUG: QR Code detected - Content: \(content), Type: \(type.title)")
            if type.title == "Wi-Fi" {
                        let wifiDetails = parseWifiQRCode(content)
                        selectedQRCard = QRCard(
                            qrString: content,
                            startTime: Date(),
                            endTime: Date(),
                            name: "",
                            lastName: "",
                            title: type.title,
                            link: content,
                            text: "",
                            number: "",
                            location: "",
                            encryption: wifiDetails.encryption,
                            address: "",
                            currency: "",
                            email: "",
                            subject: "",
                            message: "",
                            amount: "",
                            codeColor: .white,
                            backgroundColor: .black,
                                image: type.image,
                            qrType: type,
                            ssid: wifiDetails.ssid,
                            password: wifiDetails.password
                        )
            } else if type.title == "Event" {
                let eventDetails = parseEventQRCode(content)
                selectedQRCard = QRCard(
                    qrString: content,
                    startTime: eventDetails.startDate ?? Date(),
                    endTime: eventDetails.endDate ?? Date(),
                    name: eventDetails.summary,
                    lastName: "",
                    title: type.title,
                    link: content,
                    text: eventDetails.description,
                    number: "",
                    location: eventDetails.location,
                    encryption: "",
                    address: eventDetails.location,
                    currency: "",
                    email: "",
                    subject: "",
                    message: "",
                    amount: "",
                    codeColor: .white,
                    backgroundColor: .black,
                        image: type.image,
                    qrType: type,
                    ssid: "",
                    password: ""
                )
            } else if type.title == "Text" {
                let textDetails = parseTextQRCode(content)
                selectedQRCard = QRCard(
                    qrString: content,
                    startTime: Date(),
                    endTime: Date(),
                    name: textDetails.name,
                    lastName: "",
                    title: type.title,
                    link: content,
                    text: textDetails.text,
                    number: "",
                    location: "",
                    encryption: "",
                    address: "",
                    currency: "",
                    email: "",
                    subject: "",
                    message: "",
                    amount: "",
                    codeColor: .white,
                    backgroundColor: .black,

                        image: type.image,
                    qrType: type,
                    ssid: "",
                    password: ""
                )
            } else if type.title == "Contact" {
                let contactDetails = parseContactQRCode(content)
                selectedQRCard = QRCard(
                    qrString: content,
                    startTime: Date(),
                    endTime: Date(),
                    name: contactDetails.name,
                    lastName: contactDetails.lastName,
                    title: type.title,
                    link: "",
                    text: "",
                    number: contactDetails.number,
                    location: "",
                    encryption: "",
                    address: "",
                    currency: "",
                    email: "",
                    subject: "",
                    message: "",
                    amount: "",
                    codeColor: .white,
                    backgroundColor: .black,

                        image: type.image,
                    qrType: type,
                    ssid: "",
                    password: ""
                )
            } else if type.title == "Email" {
                let emailDetails = parseEmailQRCode(content)
                selectedQRCard = QRCard(
                    qrString: content,
                    startTime: Date(),
                    endTime: Date(),
                    name: "",
                    lastName: "",
                    title: type.title,
                    link: "",
                    text: "",
                    number: "",
                    location: "",
                    encryption: "",
                    address: "",
                    currency: "",
                    email: emailDetails.email,
                    subject: emailDetails.subject,
                    message: emailDetails.message,
                    amount: "",
                    codeColor: .white,
                    backgroundColor: .black,

                        image: type.image,
                    qrType: type,
                    ssid: "",
                    password: ""
                )
            } else if type.title == "Crypto" {
                let cryptoDetails = parseCryptoQRCode(content)
                selectedQRCard = QRCard(
                    qrString: content,
                    startTime: Date(),
                    endTime: Date(),
                    name: cryptoDetails.name,
                    lastName: "",
                    title: type.title,
                    link: "",
                    text: "",
                    number: "",
                    location: "",
                    encryption: "",
                    address: cryptoDetails.address,
                    currency: cryptoDetails.name,
                    email: "",
                    subject: "",
                    message: "",
                    amount: cryptoDetails.amount,
                    codeColor: .white,
                    backgroundColor: .black,
                        image: type.image,
                    qrType: type,
                    ssid: "",
                    password: ""
                )
            } else if type.title == "Website" {
                selectedQRCard = QRCard(qrString: content, startTime: Date(), endTime: Date(), name: "", lastName: "", title: type.title, link: content, text: "",
                    number: "",
                    location: "",
                    encryption: "",
                    address: "",
                    currency: "",
                    email: "",
                    subject: "",
                    message: "",
                    amount: "",
                    codeColor: .white,
                    backgroundColor: .black,
                                            image: type.image,
                    qrType: type,
                    ssid: "",
                    password: ""
                )
            } else if type.title == "Location" {
                let locationDetails = parseLocationQRCode(content)
                selectedQRCard = QRCard(
                    qrString: content,
                    startTime: Date(),
                    endTime: Date(),
                    name: locationDetails.name,
                    lastName: "",
                    title: type.title,
                    link: "",
                    text: locationDetails.location,
                    number: "",
                    location: locationDetails.location,
                    encryption: "",
                    address: "",
                    currency: "",
                    email: "",
                    subject: "",
                    message: "",
                    amount: "",
                    codeColor: .white,
                    backgroundColor: .black,
                        image: type.image,
                    qrType: type,
                    ssid: "",
                    password: ""
                )
            } else if type.title == "General" {
                let generalDetails = parseGeneralQRCode(content)
                selectedQRCard = QRCard(
                    qrString: content,
                    startTime: Date(),
                    endTime: Date(),
                    name: generalDetails.name,
                    lastName: "",
                    title: generalDetails.name,
                    link: generalDetails.content,
                    text: generalDetails.content,
                    number: "",
                    location: "",
                    encryption: "",
                    address: "",
                    currency: "",
                    email: "",
                    subject: "",
                    message: "",
                    amount: "",
                    codeColor: .white,
                    backgroundColor: .black,
                        image: type.image,
                    qrType: type,
                    ssid: "",
                    password: ""
                )
            } else {
                selectedQRCard = QRCard(
                  qrString: content,
                  startTime: Date(),
                  endTime: Date(),
                      name: type.title == "Phone" ? content : "",
                      lastName: "",
                      title: type.title,
                      link: content,
                      text: type.title == "Text" ? content : "",
                      number: type.title == "Phone" ? content : "",
                      location: type.title == "Location" ? content : "",
                      encryption: "",
                      address: "",
                      currency: type.title == "Crypto" ? content : "",
                      email: type.title == "Email" ? content : "",
                      subject: "",
                      message: "",
                      amount: "",
                      codeColor: .white,
                      backgroundColor: .black,
                      image: type.image,
                      qrType: type,
                      ssid: "",
                      password: ""
                  )
            }
        } else {
            presentError("No QR code found in the selected image.")
        }
    }
    

    private func scanQRCode(from image: UIImage) -> (content: String, type: QRType)? {
        guard let ciImage = CIImage(image: image) else {
            print("DEBUG: Failed to create CIImage from UIImage.")
            return nil
        }

        let context = CIContext()
        let options: [String: Any] = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: options)
        let features = detector?.features(in: ciImage) as? [CIQRCodeFeature]

        guard let qrContent = features?.first?.messageString else {
            print("DEBUG: No QR code detected in the image.")
            return nil
        }

        let qrType = detectQRType(from: qrContent)
        return (content: qrContent, type: qrType)
    }
    
    private func detectQRType(from qrString: String) -> QRType {
        let trimmedQRString = qrString.trimmingCharacters(in: .whitespacesAndNewlines)
        let textPattern = #"^.+(\n.+)*$"#
        let generalPatternNew = #"^[^\n]+\n[^\n]+$"#
        let wifiPattern = #"^WIFI:((T:[^;]*;)?(S:[^;]*;)?(P:[^;]*;)?)+;$"#
        let locationPattern = #"^geo:[-+]?[0-9]*\.?[0-9]+,[-+]?[0-9]*\.?[0-9]+(\n.*)*$"#
        let urlPattern = #"^((http|https)://)?(www\.)?[a-zA-Z0-9\-._~:/?#@!$&'()*+,;=%]+$"#
        let btcPattern = #"^(1|3|bc1)[a-zA-HJ-NP-Z0-9]{25,42}$"#
        let ethPattern = #"^0x[a-fA-F0-9]{40}$"#
        let solPattern = #"^[a-zA-Z0-9]{43,44}$"#
        let trxPattern = #"^T[a-zA-Z0-9]{33}$"#
        
        if trimmedQRString.range(of: wifiPattern, options: .regularExpression) != nil {
            return QRType(image: "wifi", title: "Wi-Fi")
        } else if trimmedQRString.range(of: locationPattern, options: .regularExpression) != nil {
            return QRType(image: "location", title: "Location")
        } else if trimmedQRString.contains("blockchain.com") ||
                    trimmedQRString.contains("etherscan.io") ||
                    trimmedQRString.contains("tronscan.org") ||
                    trimmedQRString.contains("solana.com") ||
                    (trimmedQRString.range(of: btcPattern, options: .regularExpression) != nil) ||
                    (trimmedQRString.range(of: ethPattern, options: .regularExpression) != nil) ||
                    (trimmedQRString.range(of: solPattern, options: .regularExpression) != nil) ||
                    (trimmedQRString.range(of: trxPattern, options: .regularExpression) != nil) {
            return QRType(image: "crypto", title: "Crypto")
        } else if trimmedQRString.range(of: "^[0-9\\-\\s]+$", options: .regularExpression) != nil {
            return QRType(image: "phone", title: "Phone")
        } else if trimmedQRString.starts(with: "BEGIN:VCARD") {
            return QRType(image: "user", title: "Contact")
        } else if trimmedQRString.starts(with: "mailto:") {
            return QRType(image: "email", title: "Email")
        } else if trimmedQRString.starts(with: "BEGIN:VEVENT") || trimmedQRString.starts(with: "BEGIN:VCALENDAR") {
            return QRType(image: "date", title: "Event")
        } else if trimmedQRString.range(of: urlPattern, options: .regularExpression) != nil {
            return QRType(image: "web", title: "Website")
        } else if trimmedQRString.range(of: textPattern, options: .regularExpression) != nil {
            return QRType(image: "text", title: "Text")
        } else if trimmedQRString.range(of: generalPatternNew, options: .regularExpression) != nil {
            return QRType(image: "qr", title: "General")
        } else {
            return QRType(image: "qr", title: "General")
        }
    }

    private func presentError(_ message: String) {
        errorMessage = message
        showError.toggle()
    }

    private func toggleFlashlight() {
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else { return }
        do {
            try device.lockForConfiguration()
            device.torchMode = isFlashOn ? .off : .on
            isFlashOn.toggle()
            device.unlockForConfiguration()
        } catch {
            print("ERROR: Flashlight cannot be toggled.")
        }
    }
    
    func checkCameraPermission() {
        Task {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                cameraPermission = .approved
                setupCamera()
            case .notDetermined:
                if await AVCaptureDevice.requestAccess(for: .video) {
                    cameraPermission = .approved
                    setupCamera()
                } else {
                    cameraPermission = .denied
                    presentError("Please Provide Access to your Camera for scanning.")
                }
            case .denied, .restricted:
                cameraPermission = .denied
                presentError("Please Provide Access to your Camera for scanning.")
            default:
                break
            }
        }
    }
    
    func setupCamera() {
        do {
            guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first else {
                presentError("Unknown device error")
                return
            }
            let input = try AVCaptureDeviceInput(device: device)
            guard session.canAddInput(input), session.canAddOutput(qrOutput) else {
                presentError("Unknown input/output error")
                return
            }

            session.beginConfiguration()
            session.addInput(input)
            session.addOutput(qrOutput)
            qrOutput.metadataObjectTypes = [.qr]
            qrOutput.setMetadataObjectsDelegate(qrDelegate, queue: .main)
            session.commitConfiguration()
            DispatchQueue.global(qos: .background).async {
                session.startRunning()
            }
        } catch {
            presentError(error.localizedDescription)
        }
    }
    
    //MARK: - Parsing
    private func parseEventQRCode(_ qrString: String) -> (summary: String, location: String, startDate: Date?, endDate: Date?, description: String) {
        let lines = qrString.split(separator: "\n").map { String($0) }
        
        var summary = ""
        var location = ""
        var startDate: Date? = nil
        var endDate: Date? = nil
        var description = ""

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        for line in lines {
            if line.starts(with: "SUMMARY:") {
                summary = line.replacingOccurrences(of: "SUMMARY:", with: "").trimmingCharacters(in: .whitespaces)
            } else if line.starts(with: "LOCATION:") {
                location = line.replacingOccurrences(of: "LOCATION:", with: "").trimmingCharacters(in: .whitespaces)
            } else if line.starts(with: "DTSTART:") {
                let dateString = line.replacingOccurrences(of: "DTSTART:", with: "").trimmingCharacters(in: .whitespaces)
                startDate = dateFormatter.date(from: dateString)
            } else if line.starts(with: "DTEND:") {
                let dateString = line.replacingOccurrences(of: "DTEND:", with: "").trimmingCharacters(in: .whitespaces)
                endDate = dateFormatter.date(from: dateString)
            } else if line.starts(with: "DESCRIPTION:") {
                description = line.replacingOccurrences(of: "DESCRIPTION:", with: "").trimmingCharacters(in: .whitespaces)
            }
        }

        return (summary, location, startDate, endDate, description)
    }
    
    private func parseContactQRCode(_ qrString: String) -> (name: String, lastName: String, number: String) {
        var name = ""
        var lastName = ""
        var number = ""

        let lines = qrString.split(separator: "\n").map { String($0) }
            for line in lines {
                if line.starts(with: "FN:") {
                    name = line.replacingOccurrences(of: "FN:", with: "").trimmingCharacters(in: .whitespaces)
                } else if line.starts(with: "N:") {
                    let parts = line.replacingOccurrences(of: "N:", with: "").split(separator: ";").map { String($0) }
                    name = parts.first ?? ""
                    lastName = parts.count > 1 ? parts[1] : ""
                } else if line.starts(with: "TEL:") || line.starts(with: "TEL;TYPE=CELL:") {
                    number = line
                        .replacingOccurrences(of: "TEL;TYPE=CELL:", with: "")
                        .replacingOccurrences(of: "TEL:", with: "")
                        .trimmingCharacters(in: .whitespaces)
                }
            }
        return (name: name, lastName: lastName, number: number)
    }
    
    private func parseWifiQRCode(_ qrString: String) -> (ssid: String, password: String, encryption: String) {
        let trimmedString = qrString.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmedString.starts(with: "WIFI:") else { return ("", "", "") }

        var ssid = ""
        var password = ""
        var encryption = ""

        let components = trimmedString.dropFirst(5).split(separator: ";").map { String($0) }
        for component in components {
            if component.starts(with: "T:") {
                encryption = String(component.dropFirst(2))
            } else if component.starts(with: "S:") {
                ssid = String(component.dropFirst(2))
            } else if component.starts(with: "P:") {
                password = String(component.dropFirst(2))
            }
        }

        return (ssid, password, encryption)
    }
    
    private func parseTextQRCode(_ qrString: String) -> (name: String, text: String) {
        let decodedString = qrString.removingPercentEncoding ?? qrString

        let lines = decodedString.split(separator: "\n").map { String($0) }
        let name = lines.first ?? "Unknown"
        let text = lines.dropFirst().joined(separator: "\n")
        
        return (name: name, text: text)
    }
    
    private func parseEmailQRCode(_ qrString: String) -> (email: String, subject: String, message: String) {
        guard qrString.starts(with: "mailto:") else { return ("", "", "") }
        let mailtoContent = qrString.replacingOccurrences(of: "mailto:", with: "")

        let components = mailtoContent.split(separator: "?", maxSplits: 1).map { String($0) }
        let email = components.first ?? ""
        var subject = ""
        var message = ""

        if components.count > 1 {
            let queryItems = components[1].split(separator: "&").map { String($0) }
            for item in queryItems {
                if item.starts(with: "subject=") {
                    subject = item.replacingOccurrences(of: "subject=", with: "").removingPercentEncoding ?? ""
                } else if item.starts(with: "body=") {
                    message = item.replacingOccurrences(of: "body=", with: "").removingPercentEncoding ?? ""
                }
            }
        }
        
        return (email: email, subject: subject, message: message)
    }

    private func parseCryptoQRCode(_ qrString: String) -> (name: String, address: String, amount: String) {
        var name = ""
        var address = ""
        var amount = ""

        let trimmedQRString = qrString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let btcRange = trimmedQRString.range(of: #"^(1|3|bc1)[a-zA-HJ-NP-Z0-9]{25,42}$"#, options: .regularExpression) {
            name = "BTC"
            address = String(trimmedQRString[btcRange])
        } else if let ethRange = trimmedQRString.range(of: #"^0x[a-fA-F0-9]{40}$"#, options: .regularExpression) {
            name = "ETH"
            address = String(trimmedQRString[ethRange])
        } else if let solRange = trimmedQRString.range(of: #"^[a-zA-Z0-9]{43,44}$"#, options: .regularExpression) {
            name = "SOL"
            address = String(trimmedQRString[solRange])
        } else if let trxRange = trimmedQRString.range(of: #"^T[a-zA-Z0-9]{33}$"#, options: .regularExpression) {
            name = "TRX"
            address = String(trimmedQRString[trxRange])
        } else if trimmedQRString.starts(with: "https://") {
            if let baseURL = trimmedQRString.split(separator: "?").first {
                if baseURL.contains("blockchain.com") {
                    name = "BTC"
                } else if baseURL.contains("etherscan.io") {
                    name = "ETH"
                } else if baseURL.contains("tronscan.org") {
                    name = "TRX"
                } else if baseURL.contains("explorer.solana.com") {
                    name = "SOL"
                }
                address = baseURL.split(separator: "/").last.map { String($0) } ?? ""
            }

            if let query = trimmedQRString.split(separator: "?").last {
                let queryItems = query.split(separator: "&").map { String($0) }
                for item in queryItems {
                    if item.starts(with: "amount=") {
                        amount = item.replacingOccurrences(of: "amount=", with: "").trimmingCharacters(in: .whitespaces)
                    }
                }
            }
        } else if let colonIndex = trimmedQRString.firstIndex(of: ":") {
            name = String(trimmedQRString[..<colonIndex])
            let rest = String(trimmedQRString[trimmedQRString.index(after: colonIndex)...])

            if let questionMarkIndex = rest.firstIndex(of: "?") {
                address = String(rest[..<questionMarkIndex])
                let params = String(rest[rest.index(after: questionMarkIndex)...])
                let queryItems = params.split(separator: "&").map { String($0) }

                for item in queryItems {
                    if item.starts(with: "amount=") {
                        amount = item.replacingOccurrences(of: "amount=", with: "").trimmingCharacters(in: .whitespaces)
                    }
                }
            } else {
                address = rest
            }
        }

        return (name: name, address: address, amount: amount)
    }

    private func parseLocationQRCode(_ qrString: String) -> (name: String, location: String) {
        let lines = qrString.split(separator: "\n").map { $0.trimmingCharacters(in: .whitespaces) }
        var name = ""
        var location = ""

        for line in lines {
            if line.starts(with: "geo:") {
                continue
            } else if name.isEmpty {
                name = line
            } else {
                location += (location.isEmpty ? "" : "\n") + line
            }
        }

        return (name: name, location: location)
    }
    private func parseGeneralQRCode(_ qrString: String) -> (name: String, content: String) {
        let components = qrString.split(separator: "\n", omittingEmptySubsequences: true).map { String($0) }
        let name = components.first ?? ""
        let content = components.dropFirst().joined(separator: "\n")
        return (name: name, content: content)
    }
}

class QRScannerDelegate: NSObject, ObservableObject, AVCaptureMetadataOutputObjectsDelegate {
    @Published var detectedQR: String? = nil
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              metadataObject.type == .qr,
              let qrString = metadataObject.stringValue else {
            return
        }
        detectedQR = qrString
    }
}


