//
//  Product.swift
//  SMB
//
//  Created by Mateusz Dylewski on 06/11/2022.
//

import SwiftUI

struct ProductModel : Identifiable, Encodable, Decodable {
    var id: String
    var name: String
    var price: Double
    var quantity: Int64
    var isBought: Bool
    var isPrivate: Bool
}

extension Encodable {
    var toDictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
    }
}

struct ProductRow: View {
    @Environment(\.editMode) private var editMode
    @Binding var product: ProductModel
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
        } else {
            HStack {
                Text(product.name)
                if displayQuantity {
                    Text(String("x\(product.quantity)"))
                        .padding(.trailing, 10)
                }
                Spacer()
                if displayPrice {
                    Text(String(product.price) + currencie)
                        .padding(.trailing, 10)
                }
                
                Image(systemName: product.isBought ? "checkmark.circle" : "circle")
                .foregroundColor(product.isBought ? .green : .accentColor)
                .onTapGesture {
                    product.isBought.toggle()
                    productService.updateById(updatedProduct: product)
                }
            }
        }
    }
    
    let amountFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
     }()
}
