//
//  ShopService.swift
//  SMB
//
//  Created by Mateusz Dylewski on 11/01/2023.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseDatabaseSwift
import MapKit

class ShopService: ObservableObject {
    
    @Published
    var shopList = [ShopModel]()
    
    private let ref = Database.database()
        .reference()
        .child("users")
        .child(Auth.auth().currentUser!.uid)
        .child("shops")
    
    func getShops() {
        ref.observe(.value) { parentSnapshot  in
            guard let children = parentSnapshot.children.allObjects as? [DataSnapshot] else {
                print("Cannot fetch public products")
                return
            }
            self.shopList = [ShopModel]()
            for rawShop in children {
                let shop : ShopModel = try! rawShop.data(as: ShopModel.self)
                self.shopList.append(shop)
            }
        }
    }
    
    func deleteById(at indexSet: IndexSet) {
        let shopIdToDelete = indexSet.map {
            self.shopList[$0].id
        }.first
        
        if let shopIdToDelete = shopIdToDelete {
            let objectRef = ref.child(shopIdToDelete)
            objectRef.removeValue()
        }
    }
    
    func insert(_ shop: ShopModel) -> ShopModel {
        var shopWithId = shop
        let objectRef = ref.childByAutoId()
        shopWithId.id = objectRef.key!
        objectRef.setValue(shopWithId.toDictionary)
        return shopWithId
    }
    
    func updateById(_ updatedShop: ShopModel) {
        ref.updateChildValues([updatedShop.id : updatedShop.toDictionary!])
    }
    
    func updateAll() {
        for product in shopList {
            updateById(product)
        }
    }
}
