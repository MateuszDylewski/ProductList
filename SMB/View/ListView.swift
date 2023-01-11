//
//  ContentView.swift
//  SMB
//
//  Created by Mateusz Dylewski on 06/11/2022.
//

import SwiftUI

struct ListView: View {
    
    @StateObject
    var productService: ProductService
    
    @Environment(\.editMode)
    private var editMode
    
    @AppStorage("privateSwitch")
    private var privateSwitch: Bool = true
    
    var body: some View {
        VStack {
            List {
                ForEach($productService.privateProductList, id: \.id) { product in
                    ProductRow(product: product, productService: productService)
                }
                .onDelete(perform: productService.deletePrivateProductById(at:))
                
                ForEach($productService.publicProductList, id: \.id) { product in
                    ProductRow(product: product, productService: productService)
                }
                .onDelete(perform: productService.deletePublicProductById(at:))
            }
            .listStyle(.plain)
            .font(.system(size:20))
            .onAppear {
                productService.getProducts(privateSwitch)
            }
            
            Spacer()
            
        }
        .ignoresSafeArea(.all,  edges: .bottom)
        .navigationTitle(privateSwitch ? "Private products" : "Private and public products")
        .navigationBarBackButtonHidden(editMode?.wrappedValue.isEditing == true ? true : false)
        .toolbar {
            editButton
            if (editMode?.wrappedValue.isEditing == true) {
                privateViewSwitch
                NavigationLink(destination: AddProductView(productService: productService), label: {
                    Text("Add")
                })
            }
        }
    }
    
    var editButton: some View {
        Button {
            if (editMode?.wrappedValue.isEditing == true) {
                productService.updateAll()
                editMode?.wrappedValue = .inactive
            } else {
                editMode?.wrappedValue = .active
            }
        } label: {
            if (editMode?.wrappedValue.isEditing == true) {
                Text("Done")
            } else {
                Text("Edit")
            }
        }
    }
    
    var privateViewSwitch : some View {
        Button {
            privateSwitch.toggle()
            productService.getProducts(privateSwitch)
        } label: {
            Text("Switch Mode")
        }
    }
}
