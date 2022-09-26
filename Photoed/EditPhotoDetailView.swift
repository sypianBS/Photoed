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
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: self.contentMode)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            .onTapGesture(count: 2) {
                withAnimation{
                    self.contentMode = self.contentMode == .fit ? .fill : .fit
                }
            } ///double tap will toggle between the modes
    }
}
