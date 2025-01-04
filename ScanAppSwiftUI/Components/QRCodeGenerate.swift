//
//  QRCodeGenerate.swift
//  ScanAppSwiftUI
//
//  Created by Macbook on 05/11/2024.
//

import Foundation
import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRCodeGenerate: View {
    let contex = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    var url: String
    var codeColor: UIColor = .black
    var backgroundColor: UIColor = .white
    var body: some View {
        Image(uiImage: imageGenerate(url))
            .interpolation(.none)
            .resizable()
            .frame(maxWidth: .infinity)
    }
    
    func imageGenerate(_ url: String) -> UIImage {
        let data = Data(url.utf8)
        filter.setValue(data, forKey: "inputMessage")
        if let qrcode = filter.outputImage {
        let coloredQRCode = applyColors(to: qrcode)
            if let qrcodeImage = contex.createCGImage(coloredQRCode, from: coloredQRCode.extent) {
                return UIImage(cgImage: qrcodeImage)
            }
        }
        return UIImage(systemName: "xmark") ?? UIImage()
    }
    
    func applyColors(to image: CIImage) -> CIImage {
        let colorFilter = CIFilter.falseColor()
        colorFilter.inputImage = image
        colorFilter.setValue(CIColor(color: codeColor), forKey: "inputColor1")
        colorFilter.setValue(CIColor(color: backgroundColor), forKey: "inputColor0")
        return colorFilter.outputImage ?? image
    }
}

