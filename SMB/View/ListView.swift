//
//  ContentView.swift
//  SMB
//
//  Created by Mateusz Dylewski on 06/11/2022.
//

import SwiftUI

struct ListView: View {
    @ObservedObject var productService: ProductService
    @Environment(\.editMode) private var editMode
    
    var body: some View {
        VStack {
            List {
                ForEach(productService.productsList, id: \.id) { product in
                    ProductRow(product: product, productService: productService)
                }
                .onDelete(perform: productService.deleteById(at:))
            }
            .listStyle(.plain)
            .font(.system(size:20))
            .onAppear {
                productService.getAll()
            }
            
            Spacer()
            
        }
        .ignoresSafeArea(.all,  edges: .bottom)
        .navigationTitle("\(productService.productsList.count) Items")
        .toolbar{
            if editMode?.wrappedValue.isEditing == true {
                NavigationLink(destination: AddProductView(productService: productService), label: {
                    Text("Add")
                })
            }
            EditButton()
        }
    }
}

struct Listy_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
