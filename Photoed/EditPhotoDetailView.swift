//
//  EditPhotoDetailView.swift
//  Photoed
//
//  Created by Beniamin on 26.09.22.
//

import SwiftUI

struct EditPhotoDetailView: View {
    @State var contentMode: ContentMode = .fit
    var image: UIImage
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: self.contentMode)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                    .onTapGesture(count: 2) {
                        withAnimation{
                            self.contentMode = self.contentMode == .fit ? .fill : .fit
                        }
                    } //double tap will toggle between the modes
                editPhotoFooterView
                    .frame(maxWidth: .infinity, minHeight: 80, maxHeight: 100)
            }
        }
    }
    
    var editPhotoFooterView: AnyView {
        return AnyView (
                HStack(spacing: 32) {
                    Button("Theme", action: {})
                        .buttonStyle(EditPhotoButtonStyle())
                    Button("Color", action: {})
                        .buttonStyle(EditPhotoButtonStyle())
                    Button("Crop", action: {})
                        .buttonStyle(EditPhotoButtonStyle())
                    Button("Save", action: {
                        PhotoSaver().writeToPhotoAlbum(image: image)
                    }).buttonStyle(EditPhotoButtonStyle())
                }
        )
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

