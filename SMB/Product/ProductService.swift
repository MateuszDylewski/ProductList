//
//  ProductListViewModel.swift
//  SMB
//
//  Created by Mateusz Dylewski on 10/11/2022.
//

import Foundation

class ProductService: ObservableObject {
    @Published var productsList: [ProductModel] = []
    
    func getAll() {
        productsList = ProductStore.shared.getProducts()
    }
    
    func deleteById(at indexSet: IndexSet) {
        let id = indexSet.map { self.productsList[$0].id}.first
        if let id = id {
            let isDeleted = ProductStore.shared.delete(id: id)
            if isDeleted {
                getAll()
            }
        }
    }
    
    func insert(product: ProductModel) {
        let isInserted = ProductStore.shared.insert(product)
        if isInserted {
            getAll()
        }
    }
    
    func updateById(updatedProduct: ProductModel) {
        let isUpdated = ProductStore.shared.update(updatedProduct: updatedProduct)
        if isUpdated {
            getAll()
        }
    }
}
