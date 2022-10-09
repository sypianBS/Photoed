//
//  PhotoedApp.swift
//  Photoed
//
//  Created by Beniamin on 25.09.22.
//

import SwiftUI

@main
struct PhotoedApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(PhotoViewModel.shared)
        }
    }
}
