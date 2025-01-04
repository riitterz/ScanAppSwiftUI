//
//  BackButton.swift
//  ScanAppSwiftUI
//
//  Created by Macbook on 13/11/2024.
//

import SwiftUI

struct BackButton: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image("back")
        }
    }
}

struct BackButton_Previews: PreviewProvider {
    static var previews: some View {
        BackButton()
    }
}
