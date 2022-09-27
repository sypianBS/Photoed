//
//  EditPhotoFooterView.swift
//  Photoed
//
//  Created by Beniamin on 27.09.22.
//

import SwiftUI

struct EditPhotoFooterView: View {
    var body: some View {
        HStack(spacing: 32) {
            Button("Theme", action: {})
                .buttonStyle(EditPhotoButtonStyle())
            Button("Color", action: {})
                .buttonStyle(EditPhotoButtonStyle())
            Button("Crop", action: {})
                .buttonStyle(EditPhotoButtonStyle())
        }
    }
}

struct EditPhotoButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Font.system(size: 16).bold())
            .foregroundColor(.white)
            .opacity(configuration.isPressed ? 0.1 : 1.0)
    }
}
