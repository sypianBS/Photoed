//
//  ContentView.swift
//  Photoed
//
//  Created by Beniamin on 25.09.22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        //used to divide the screen into 3 equal spaces
        GeometryReader { geo in
            VStack {
                logoView.frame(height: geo.size.height*1/3)
                
                pickPhotoView.frame(height: geo.size.height*1/3)
                
                exitButtonView.frame(height: geo.size.height*1/3)
                
            }.frame(maxWidth: .infinity) //take entire screen width
        }
    }
    
    var logoView: AnyView {
        return AnyView(
            Text("Photoed")
                .font(.title))
    }
    
    var pickPhotoView: AnyView {
        return AnyView(VStack {
            ZStack {
                Circle()
                    .stroke(style: StrokeStyle(lineWidth: 3, dash: [3]))
                    .frame(width: 300, height: 300)
                Image(systemName: "photo.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
            }
            
            Button {
                print("tapped")
            } label: {
                Text("Tap to pick photo")
            }
        })
    }
    
    var exitButtonView: AnyView {
        return AnyView( Button {
            print("Exit tapped")
        } label: {
            Text("Exit")
                .foregroundColor(.red)
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
