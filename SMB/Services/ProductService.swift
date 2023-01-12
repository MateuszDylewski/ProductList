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
    var publicProductList = [ProductModel]()
    
    @Published
    var privateProductList = [ProductModel]()
    
    private let ref = Database.database().reference()
    private let currentUserId = Auth.auth().currentUser!.uid
    
    func getProducts(_ privateSwitch: Bool) {
        self.publicProductList = [ProductModel]()
        self.privateProductList = [ProductModel]()
        readPrivateProducts()
        if !privateSwitch {
            readPublicProducts()
        }
    }
    
    func readPublicProducts() {
        ref.child("products").observe(.value) { parentSnapshot  in
            guard let children = parentSnapshot.children.allObjects as? [DataSnapshot] else {
                print("Cannot fetch public products")
                return
            }
            self.publicProductList = [ProductModel]()
            for rawProduct in children {
                let product : ProductModel = try! rawProduct.data(as: ProductModel.self)
                self.publicProductList.append(product)
            }
        }
    }
    
    func readPrivateProducts() {
        ref.child("users").child(currentUserId).child("products").observe(.value) { parentSnapshot in
            guard let children = parentSnapshot.children.allObjects as? [DataSnapshot] else {
                print("Cannot fetch private products")
                return
            }
            self.privateProductList = [ProductModel]()
            for rawProduct in children {
                let product : ProductModel = try! rawProduct.data(as: ProductModel.self)
                self.privateProductList.append(product)
            }
        }
    }
    
    func deletePublicProductById(at indexSet: IndexSet) {
        let productIdToDelete = indexSet.map {
            self.publicProductList[$0].id
        }.first
        
        if let productIdToDelete = productIdToDelete {
            let objectRef = ref.child("products").child(productIdToDelete)
            objectRef.removeValue()
        }
    }
    
    func deletePrivateProductById(at indexSet: IndexSet) {
        let productIdToDelete = indexSet.map {
            self.privateProductList[$0].id
        }.first
        
        if let productIdToDelete = productIdToDelete {
            let objectRef = ref.child("users").child(currentUserId).child("products").child(productIdToDelete)
            objectRef.removeValue()
        }
    }
    
    func insert(product: ProductModel) {
        var productWithId = product
        let objectRef: DatabaseReference
        
        if product.isPrivate {
            objectRef = ref.child("users").child(currentUserId).child("products").childByAutoId()
        } else {
            objectRef = ref.child("products").childByAutoId()
        }
        productWithId.id = objectRef.key!
        objectRef.setValue(productWithId.toDictionary)
    }
    
    func updateById(updatedProduct: ProductModel) {
        if updatedProduct.isPrivate {
            ref.child("users")
                .child(currentUserId)
                .child("products")
                .updateChildValues([updatedProduct.id : updatedProduct.toDictionary!])
        } else {
            ref.child("products")
                .updateChildValues([updatedProduct.id : updatedProduct.toDictionary!])
        }
    }
    
    func updateAll() {
        for product in privateProductList {
            updateById(updatedProduct: product)
        }
        for product in publicProductList {
            updateById(updatedProduct: product)
        }
    }
}
