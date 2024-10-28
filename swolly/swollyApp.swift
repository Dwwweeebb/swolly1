//
//  swollyApp.swift
//  swolly
//
//  Created by admin on 10/27/24.
//

import SwiftUI
import Firebase

@main
struct MuscleMiceApp: App {
    
    init () {
        FirebaseApp.configure()
        print("Firebase App Initialized")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
