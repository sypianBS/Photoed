//
//  ContentView.swift
//  Photoed
//
//  Created by Beniamin on 25.09.22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showSheetWithPicker = false
    @State private var pickedPhoto: UIImage?
    
    var body: some View {
        
        //used to divide the screen into 3 equal spaces
        GeometryReader { geo in
            VStack {
                logoView.frame(height: geo.size.height*1/3)
                
                pickPhotoView.frame(height: geo.size.height*1/3)
                
                exitButtonView.frame(height: geo.size.height*1/3)
                
            }
            .frame(maxWidth: .infinity) //take entire screen width
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.init(red: 215/255, green: 221/255, blue: 232/255), Color.init(red: 117/255, green: 127/255, blue: 154/255)]), startPoint: .top, endPoint: .bottom)
            )
            .sheet(isPresented: $showSheetWithPicker, onDismiss: nil) {
                PhotoPicker(image: $pickedPhoto)
            }
        }
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
                ZStack {
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 3, dash: [3]))
                        .frame(width: 300, height: 300)
                    Image(systemName: "photo.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                }
                
                Text("Tap image to pick a photo")
                
            }.onTapGesture {
                showSheetWithPicker = true
            }
        )
    }
    
    var exitButtonView: AnyView {
        return AnyView( Button {
            print("Exit tapped")
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .frame(width: 100, height: 40)
                    .foregroundColor(.black)
                Text("Exit")
                    .foregroundColor(.red)
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
