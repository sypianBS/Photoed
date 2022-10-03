//
//  ContentView.swift
//  Photoed
//
//  Created by Beniamin on 25.09.22.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var editPhotoViewModel = EditPhotoViewModel()
    @State private var showSheetWithPicker = false
    @State private var showEditPhotoView = false
    
    var body: some View {
        NavigationView {
            //used to divide the screen into 3 equal spaces
            GeometryReader { geo in
                VStack {
                    logoView.frame(height: geo.size.height*1/3)
                    
                    pickPhotoView.frame(height: geo.size.height*1/3)
                    
                    exitButtonView.frame(height: geo.size.height*1/3)
                    
                    editPhotoViewNavigationLink
                }
                .frame(maxWidth: .infinity) //take entire screen width
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.init(red: 215/255, green: 221/255, blue: 232/255), Color.init(red: 117/255, green: 127/255, blue: 154/255)]), startPoint: .top, endPoint: .bottom)
                ).onChange(of: editPhotoViewModel.state.inputImage, perform: { newValue in
                    guard let pickedPhoto = editPhotoViewModel.state.inputImage else {
                        showEditPhotoView = false
                        return
                    }
                    showEditPhotoView = true
                    self.editPhotoViewModel.setInputPhoto(photo: pickedPhoto)
                })
                .sheet(isPresented: $showSheetWithPicker) {
                    PhotoPicker(image: $editPhotoViewModel.state.inputImage)
                }
            }
        }.environmentObject(editPhotoViewModel)
    }
    
    var editPhotoViewNavigationLink: AnyView {
        return AnyView(
            NavigationLink(destination: EditPhotoDetailView()
                            .navigationBarHidden(true), isActive: self.$showEditPhotoView) {
                EmptyView()
            }.hidden()
        )
    }
    
    var logoView: AnyView {
        return AnyView(
            Text("Photoed")
                .font(.title)
                .bold()
                .foregroundColor(.indigo)
        )
    }
    
    var pickPhotoView: AnyView {
        return AnyView(
            VStack {
                Image(systemName: "photo.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .foregroundColor(.white)
                Text("Tap image to pick a photo")
                
            }.onTapGesture {
                showSheetWithPicker = true
            }
        )
    }
    
    var exitButtonView: AnyView {
        return AnyView(
            Text("by sypianBS")
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
