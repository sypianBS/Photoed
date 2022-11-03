//
//  ContentView.swift
//  Photoed
//
//  Created by Beniamin on 25.09.22.
//

import SwiftUI

struct ContentView: View {
    @State private var showSheetWithPicker = false
    @State private var showCameraPicker = false
    @State private var showEditPhotoView = false
    @State private var pickedImage: UIImage?
    @State private var showSourceChoiceDialog = false
    @State private var showCameraNotAvailableAlert = false
    @EnvironmentObject var editPhotoViewModel: PhotoViewModel
    
    var body: some View {
        NavigationView {
            //used to divide the screen into 3 equal spaces
            GeometryReader { geo in
                VStack {
                    logoView
                    
                    PickPhotoView()
                        .frame(height: geo.size.height*1/3)
                        .onTapGesture {
                            showSourceChoiceDialog = true
                        }
                        
                    
                    bottomTextView.frame(height: geo.size.height*1/3)
                    
                    editPhotoViewNavigationLink
                }
                .alert(isPresented: $showCameraNotAvailableAlert) {
                    Alert(title: Text("Camera not available"), message: Text("Please connect an appropriate physical device"), dismissButton: .default(Text("OK")))
                }
                .confirmationDialog("Choose source", isPresented: $showSourceChoiceDialog) {
                    VStack {
                        Button {
                            showSheetWithPicker = true
                        } label: {
                            Text("Library")
                        }

                        Button {
                            //prevent crash if someone chooses Camera on the Simulator
                            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                                showCameraPicker = true
                            } else {
                                showCameraNotAvailableAlert = true
                            }
                        } label: {
                            Text("Camera")

                        }
                    }
                }
                .navigationBarHidden(true)
                .frame(maxWidth: .infinity) //take entire screen width
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.init(red: 215/255, green: 221/255, blue: 232/255), Color.init(red: 117/255, green: 127/255, blue: 154/255)]), startPoint: .top, endPoint: .bottom)
                ).onChange(of: pickedImage, perform: { newValue in
                    print("change")
                    guard let pickedPhoto = pickedImage else {
                        showEditPhotoView = false
                        return
                    }
                    
                    editPhotoViewModel.setInputPhoto(photo: pickedPhoto)
                    showEditPhotoView = true
                })
                    .sheet(isPresented: $showSheetWithPicker) {
                        PhotoPicker(image: $pickedImage)
                    }
                    .sheet(isPresented: $showCameraPicker) {
                        CameraPicker(image: $pickedImage)
                    }
            }
        }
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
            ZStack {
                Image("photoedHeaderPic") //CC licensed image; source: https://upload.wikimedia.org/wikipedia/commons/4/4f/GND_filter_difference.jpg 
                    .resizable()
                    .ignoresSafeArea()
                Text("Photoed")
                    .font(.system(size: 36, weight: .thin, design: .monospaced)) //todoben change font
                    .rotationEffect(Angle(degrees: -3))
                    .foregroundColor(Color.init(red: 242/255, green: 221/255, blue: 28/255))
                    .offset(y: 30)
            }
        )
    }
    
    struct PickPhotoView: View {
        @State private var isAnimated = false
        @State private var dashPhase = 0.0
        
        var body: some View {
            VStack {
                Image(systemName: "plus.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .foregroundColor(.white)
                    .offset(y: 40)
            }.onAppear {
                DispatchQueue.main.async { //required to fix the weird behavior of animating the entire layout, see https://stackoverflow.com/questions/64566492/swiftui-broken-explicit-animations-in-navigationview
                    withAnimation(Animation.easeInOut(duration: 1.5).repeatForever()) {
                        isAnimated.toggle()
                    }
                    withAnimation(.linear.repeatForever(autoreverses: false)) {
                        dashPhase -= 20
                    }
                }
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
