//
//  Shop.swift
//  SMB
//
//  Created by Mateusz Dylewski on 11/01/2023.
//

import SwiftUI

struct ShopModel : Identifiable, Encodable, Decodable {
    var id: String
    var name: String
    var description: String
    var range: Int
    var latitude: Double
    var longitude: Double
}

struct ShopAdd: View {
    
    var locationService: LocationService
    
    var shopService: ShopService
    
    @Binding
    var showPopover: Bool
    
    @State
    private var newShop = ShopModel(id: "", name: "", description: "", range: 0, latitude: 0, longitude: 0)
    
    var body: some View {
        VStack {
            Text("NewShop")
                .font(.system(size: 40, weight: .bold))
                .padding(.top, 15)
                .padding(.bottom, -10)
            Form {
                TextField("Name", text: $newShop.name)
                TextField("Description", text: $newShop.description)
                TextField("range", value: $newShop.range, formatter: amountFormatter)
                Button {
                    saveShop()
                } label: {
                    Text("Save")
                        .frame(width: 300, height: 35)
                        .foregroundColor(.white)
                        .background(.blue)
                        .cornerRadius(15)
                }
            }
        }
    }
    
    func saveShop() {
        newShop.latitude = locationService.locationManager?
            .location!.coordinate.latitude ?? 0
        newShop.longitude = locationService.locationManager?
            .location!.coordinate.longitude ?? 0
        showPopover.toggle()
        shopService.insert(newShop)
    }
    
    let amountFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
     }()
}
