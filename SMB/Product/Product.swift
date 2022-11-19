//
//  Product.swift
//  SMB
//
//  Created by Mateusz Dylewski on 06/11/2022.
//

import SwiftUI

struct ProductModel : Identifiable {
    var id: Int64
    var name: String
    var price: Double
    var quantity: Int64
    var ifBought: Bool
}

struct ProductRow: View {
    @Environment(\.editMode) private var editMode
    @State var product: ProductModel
    @ObservedObject var productService: ProductService
    @AppStorage("currencie") private var currencie = "zł"
    @AppStorage("displayQuantity") private var displayQuantity = true
    @AppStorage("displayPrice") private var displayPrice = true
    
    var body: some View {
        if editMode?.wrappedValue.isEditing == true {
            VStack {
                TextField("Product Name", text: $product.name)
                
                if displayQuantity {
                    Stepper("Quantity: \(product.quantity)", value: $product.quantity, in: 0...100)
                }
                
                if displayPrice {
                    HStack {
                        Text("Price:")
                        TextField("", value: $product.price, formatter: amountFormatter)
                            .keyboardType(.decimalPad)
                    }
                }
            }
            .onDisappear {
                productService.updateById(updatedProduct: product)
            }
        } else {
            HStack {
                Text(product.name)
                if displayQuantity {
                    Text(String("x\(product.quantity)"))
                        .padding(.trailing, 10)
                }
                Spacer()
                if displayPrice {
                    Text(String(product.price) +  currencie)
                        .padding(.trailing, 10)
                }
                if editMode?.wrappedValue.isEditing == true {
                    
                } else {
                    Button {
                        product.ifBought.toggle()
                    } label: {
                        if product.ifBought {
                            Image(systemName: "checkmark.circle")
                        } else {
                            Image(systemName: "circle")
                        }
                    }
                }
            }
            .onDisappear {
                productService.updateById(updatedProduct: product)
            }
        }
    }
    
    let amountFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
     }()
}
