//
//  Permission.swift
//  ScanAppSwiftUI
//
//  Created by Macbook on 29/10/2024.
//

import Foundation
import Photos
import SwiftUI
import AVFoundation

enum Permission: String {
    case idle = "Not Determined"
    case approved = "Access Granted"
    case denied = "Access Denied"
}

func requestPhotoLibraryAccess(completion: @escaping (Bool) -> Void) {
    let status = PHPhotoLibrary.authorizationStatus()
    switch status {
    case .authorized:
        completion(true)
    case .notDetermined:
        PHPhotoLibrary.requestAuthorization { newStatus in
            DispatchQueue.main.async {
                completion(newStatus == .authorized)
            }
        }
    default:
        completion(false)
    }
}

func saveImageToPhotoLibrary(_ image: UIImage, completion: @escaping (Bool) -> Void) {
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    completion(true)
}

func downloadQRCode<T: View>(qrCodeView: T) {
    let qrCodeImage = ViewToImage(content: { AnyView(qrCodeView) }).toUIImage()

    requestPhotoLibraryAccess { granted in
        if granted {
            saveImageToPhotoLibrary(qrCodeImage) { success in
                if success {
                    print("QR Code saved to Photos successfully.")
                } else {
                    print("Failed to save QR Code to Photos.")
                }
            }
        } else {
            print("Photo Library access denied.")
        }
    }
}


