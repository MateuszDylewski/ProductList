//
//  ProductListViewModel.swift
//  SMB
//
//  Created by Mateusz Dylewski on 10/11/2022.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseDatabaseSwift

class ProductService: ObservableObject {
    @Published
    var productList = [ProductModel]()
    
    private let ref = Database.database().reference()
    private let currentUserId = Auth.auth().currentUser!.uid
    
    func getProducts(_ privateSwitch: Bool) {
        if (privateSwitch) {
            readPrivateProducts()
        } else {
            readAllProducts()
        }
    }
    
    func readAllProducts() {
        ref.observe(.value) { parentSnapshot in
                guard let children = parentSnapshot.children.allObjects as? [DataSnapshot] else {
                    print("Cannot fetch products")
                    return
                }
                self.productList = [ProductModel]()
                for rawProduct in children {
                    let product : ProductModel = try! rawProduct.data(as: ProductModel.self)
                    if (product.userOwnerId == "" || product.userOwnerId == self.currentUserId) {
                        self.productList.append(product)
                    }
                }
                
//                guard let children = parentSnapshot.children.allObjects as? [DataSnapshot] else {
//                    print("Cannot fetch products")
//                    return
//                }
//
//                self.productList = children.compactMap({snapchot in
//                    return try? snapchot.data(as: ProductModel.self)
//                })
            }
    }
    
    func readPrivateProducts() {
        ref.observe(.value) { parentSnapshot in
                guard let children = parentSnapshot.children.allObjects as? [DataSnapshot] else {
                    print("Cannot fetch products")
                    return
                }
                self.productList = [ProductModel]()
                for rawProduct in children {
                    let product : ProductModel = try! rawProduct.data(as: ProductModel.self)
                    if (product.userOwnerId == self.currentUserId) {
                        self.productList.append(product)
                    }
                }
            }
    }
    
    func deleteById(at productId: IndexSet) {
//        let id = indexSet.map { self.productsList[$0].id}.first
//        if let id = id {
//            let isDeleted = ProductStore.shared.delete(id: id)
//            if isDeleted {
//                getAll()
//            }
//        }
        //let objectRef = ref.child(String(productId))
        //TODO: delete product
        
        objectRef.remove
    }
    
    func insert(product: ProductModel) {
        var productWithId = product
        let objectRef = ref.childByAutoId()
        productWithId.id = objectRef.key!
        objectRef.setValue(productWithId.toDictionary)
        
    }
    
    func updateById(updatedProduct: ProductModel) {
        ref.updateChildValues([updatedProduct.id : updatedProduct.toDictionary!])
    }
    
    func updateAll() {
        for product in productList {
            updateById(updatedProduct: product)
        }
    }
}
