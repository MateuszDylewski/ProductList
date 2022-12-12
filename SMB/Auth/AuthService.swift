//
//  AuthService.swift
//  SMB
//
//  Created by Mateusz Dylewski on 07/12/2022.
//

import Foundation
import Firebase

class AuthService: ObservableObject {
    @Published var userIsLoggedIn: Bool = false
    @Published var authError: Bool = false
    
    func register(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
                self.authError = true
            } else {
                self.authError = false
            }
        }
    }
    
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
                self.authError = true
            } else {
                //self.userIsLoggedIn = true
                self.authError = false
            }
        }
    }
}
