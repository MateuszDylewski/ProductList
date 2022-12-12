//
//  AuthView.swift
//  SMB
//
//  Created by Mateusz Dylewski on 07/12/2022.
//

import SwiftUI
import Firebase

struct AuthView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State private var email: String = ""
    @State private var password: String = ""
    @ObservedObject var authService: AuthService

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(
                    colors: [.blue, colorScheme == .dark ? .black : .white]
                ),
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack {
                Text("Welcome!")
                    .font(.system(size: 50, weight: .bold, design: .rounded))
                    .padding(.bottom, 100)
                VStack {
                    TextField("Email", text: $email)
                        .textFieldStyle(.plain)
                        .frame(width: 350)
                    Rectangle()
                        .frame(width: 350, height: 1)
                        .padding(.bottom, 25)
                }
                
                VStack {
                    SecureField("Password", text: $password)
                        .textFieldStyle(.plain)
                        .frame(width: 350)
                    Rectangle()
                        .frame(width: 350, height: 1)
                }

                Button{
                    authService.login(email: self.email, password: self.password)
                } label: {
                    Text("Login")
                        .frame(width: 280, height: 50)
                        .foregroundColor(.white)
                        .background(.blue)
                        .cornerRadius(15)
                        .font(.system(size: 25))
                }.offset(y: 100)
                
                Button{
                    authService.register(email: self.email, password: self.password)
                } label: {
                    Text("Register")
                }.offset(y: 110)
            }
            .font(.system(size: 20, weight: .medium))
        
            if authService.authError {
                Text("Invalid email or password")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.red)
                    .offset(y: 120)
            }
        }
        .onAppear{
            Auth.auth().addStateDidChangeListener { auth, user in
                if user != nil {
                    authService.userIsLoggedIn = true
                } else {
                    authService.userIsLoggedIn = false
                }
            }
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView(authService: AuthService())
    }
}
