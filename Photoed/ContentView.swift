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
                    
                    PickPhotoView(showSheetWithPicker: $showSheetWithPicker).frame(height: geo.size.height*1/3)
                    
                    bottomTextView.frame(height: geo.size.height*1/3)
                    
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
            NavigationLink(destination: EditPhotoDetailView(), isActive: self.$showEditPhotoView) {
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
    
    struct PickPhotoView: View {
        @Binding var showSheetWithPicker: Bool
        @State var isAnimated = false
        var body: some View {
            VStack {
                ZStack {
                    Image(systemName: "photo.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                        .foregroundColor(.white)
                    Image(systemName: "hand.tap.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64)
                        .foregroundColor(.yellow)
                        .offset(x: 0, y: isAnimated ? 140 : 50)
                }
            }.onAppear {
                DispatchQueue.main.async { //required to fix the weird behavior of animating the entire layout, see https://stackoverflow.com/questions/64566492/swiftui-broken-explicit-animations-in-navigationview
                    withAnimation(Animation.easeInOut(duration: 1.5).repeatForever()) {
                        isAnimated.toggle()
                    }
                }
            }
            .onTapGesture {
                showSheetWithPicker = true
            }
        }
    }
    
    var bottomTextView: AnyView {
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
