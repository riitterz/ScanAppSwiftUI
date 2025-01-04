//
//  ViewToImage.swift
//  ScanAppSwiftUI
//
//  Created by Macbook on 02/12/2024.
//

import SwiftUI

struct ViewToImage: UIViewRepresentable {
    let content: () -> AnyView
    
    func makeUIView(context: Context) -> UIView {
        let hostingController = UIHostingController(rootView: content())
        hostingController.view.backgroundColor = .clear
        return hostingController.view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    func toUIImage() -> UIImage {
            let controller = UIHostingController(rootView: content())
            let targetSize = controller.view.intrinsicContentSize

            controller.view.frame = CGRect(origin: .zero, size: targetSize)
            controller.view.layoutIfNeeded()

            let renderer = UIGraphicsImageRenderer(size: targetSize)
            return renderer.image { context in
                controller.view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
            }
        }
}


