//
//  SMBApp.swift
//  SMB
//
//  Created by Mateusz Dylewski on 06/11/2022.
//

import SwiftUI
import Firebase

@main
struct SMBApp: App {
    
    @ObservedObject var authService: AuthService = AuthService()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if authService.userIsLoggedIn {
                HomeView(authService: self.authService)
            } else {
                AuthView(authService: self.authService)
            }
        }
    }
}
