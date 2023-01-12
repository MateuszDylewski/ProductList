//
//  HomeView.swift
//  SMB
//
//  Created by Mateusz Dylewski on 10/11/2022.
//

import Foundation
import SwiftUI

struct HomeView: View {
    
    private let adaptiveColumns = [GridItem(.adaptive(minimum: 180))]
    @ObservedObject var authService: AuthService
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: adaptiveColumns, spacing: 20) {
                    NavigationLink(destination: ListView(productService: ProductService()), label: {
                        NaviagtionButton(label: "List", image: "checklist", color: .blue)
                    })
                    NavigationLink(destination: MapView(), label: {
                        NaviagtionButton(label: "Map", image: "map", color: .green)
                    })
                    NavigationLink(destination: SettingsView(), label: {
                        NaviagtionButton(label: "Settings", image: "gear", color: .gray)
                    })
                }
            }.navigationTitle("Home")
        }
    }
}

struct NaviagtionButton: View {
    var label: String
    var image: String
    var color: Color
    
    var body: some View {
        VStack {
            Image(systemName: image)
            Text(label)
        }
        .frame(width: 180, height: 180)
        .bold()
        .font(.system(size: 30, weight: .medium, design: .rounded))
        .background(color)
        .foregroundColor(.white)
        .cornerRadius(20)
    }
}
