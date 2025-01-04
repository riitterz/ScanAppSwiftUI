//
//  ImagePicker.swift
//  ScanAppSwiftUI
//
//  Created by Macbook on 11/11/2024.
//

import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    var didSelectImage: ((UIImage?) -> Void)?
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider else {
                print("No results found")
                parent.didSelectImage?(nil)
                return
            }
            
            print("Available type identifiers: \(provider.registeredTypeIdentifiers)")
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { (object, error) in
                    DispatchQueue.main.async {
                        if let error = error {
                            print("Error loading UIImage: \(error.localizedDescription)")
                            self.parent.didSelectImage?(nil)
                            return
                        }

                        guard let image = object as? UIImage else {
                            print("Failed to cast loaded object to UIImage")
                            self.parent.didSelectImage?(nil)
                            return
                        }

                        print("UIImage loaded successfully")
                        self.parent.didSelectImage?(image)
                    }
                }
            } else if provider.hasItemConformingToTypeIdentifier("public.image") {
                provider.loadFileRepresentation(forTypeIdentifier: "public.image") { (url, error) in
                    guard let url = url else {
                        print("Failed to load file representation: \(String(describing: error))")
                        self.parent.didSelectImage?(nil)
                        return
                    }
                    do {
                        let imageData = try Data(contentsOf: url)
                        if let uiImage = UIImage(data: imageData) {
                            print("Image loaded from file representation")
                            DispatchQueue.main.async {
                                self.parent.didSelectImage?(uiImage)
                            }
                        } else {
                            print("Failed to create UIImage from file representation")
                            DispatchQueue.main.async {
                                self.parent.didSelectImage?(nil)
                            }
                        }
                    } catch {
                        print("Error loading image data: \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            self.parent.didSelectImage?(nil)
                        }
                    }
                }
            } else {
                print("Provider cannot load image or file representation")
                self.parent.didSelectImage?(nil)
            }
        }
    }
}


