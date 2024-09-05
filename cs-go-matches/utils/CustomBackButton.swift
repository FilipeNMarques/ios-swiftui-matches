//
//  CustomBackButton.swift
//  cs-go-matches
//
//  Created by Filipe Marques on 05/09/24.
//

import SwiftUI

struct CustomBackButton: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.white)
                .imageScale(.large)
        }
    }
}

#Preview {
    CustomBackButton()
}
