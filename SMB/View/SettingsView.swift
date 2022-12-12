//
//  SettingsView.swift
//  SMB
//
//  Created by Mateusz Dylewski on 14/11/2022.
//

import Foundation
import SwiftUI
import Firebase

struct SettingsView: View {
    @AppStorage("currencie") private var currencie = "zł"
    @AppStorage("displayQuantity") private var displayQuantity = true
    @AppStorage("displayPrice") private var displayPrice = true
    
    var body: some View {
        Form {
            Section("Currency", content: {
                TextField("Currency", text: $currencie)
            })
            Section("Display", content: {
                Toggle(isOn: $displayQuantity, label: {
                    Text("Quantity")
                })
                Toggle(isOn: $displayPrice, label: {
                    Text("Price")
                })
            })
            Section("Account", content: {
                Button {
                    do {
                        try Auth.auth().signOut()
                    } catch {
                        print("Cannot sign out user: \(error)")
                    }
                } label: {
                    Text("Sign out")
                }
            })
        }
        .navigationTitle("Settings")
    }
}
