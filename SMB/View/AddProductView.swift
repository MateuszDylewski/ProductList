//
//  AddProductView.swift
//  SMB
//
//  Created by Mateusz Dylewski on 11/11/2022.
//

import Foundation
import SwiftUI
import Firebase

struct AddProductView: View {
    
    @Environment(\.presentationMode)
    var presentationMode: Binding<PresentationMode>
    
    @ObservedObject
    var productService: ProductService
    
    @State
    private var name: String = ""
    
    @State
    private var quantity: Int64 = 0
    
    @State
    private var price: Double = 0.0
    
    @State
    private var isPrivate: Bool = false
    
    @AppStorage("displayQuantity")
    private var displayQuantity = true
    
    @AppStorage("displayPrice")
    private var displayPrice = true
    
    var body: some View {
        Form {
            TextField("Product Name", text: $name)
        
            if displayQuantity {
                Stepper("Quantity: \(quantity)", value: $quantity, in: 0...100)
            }
            
            if displayPrice {
                TextField("", value: $price, formatter: amountFormatter)
                    .keyboardType(.decimalPad)
            }
            Toggle("Private product", isOn: $isPrivate)
        }
        .navigationTitle("Add product")
        .toolbar {
            Button {
                productService.insert(product: ProductModel(
                    id: "",
                    name: self.name,
                    price: self.price,
                    quantity: self.quantity,
                    ifBought: false,
                    userOwnerId: isPrivate ? Auth.auth().currentUser!.uid : ""
                ))
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Save")
            }
            .disabled(checkForm())
        }
    }
    
    let amountFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
     }()
    
    func checkForm() -> Bool {
        if self.name == "" {
            return true
        }
        return false
    }
}

struct Add_Previews: PreviewProvider {
    static var previews: some View {
        AddProductView(productService: ProductService())
    }
}
