//
//  ProductStore.swift
//  SMB
//
//  Created by Mateusz Dylewski on 09/11/2022.
//

import SQLite
import Foundation

class ProductStore {
    
    static let dbName = "database.sqlite3"
    
    private let products = Table("products")
    private let id = Expression<Int64>("id")
    private let name = Expression<String>("name")
    private let price = Expression<Double>("price")
    private let quantity = Expression<Int64>("quantity")
    private let ifBought = Expression<Bool>("ifBought")
    
    static let shared = ProductStore()
    
    private var db: Connection? = nil
    
    private init() {
        
        if let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let dirPath = docDir.appendingPathComponent("database")

            do {
                try FileManager.default.createDirectory(atPath: dirPath.path, withIntermediateDirectories: true, attributes: nil)
                let dbPath = dirPath.appendingPathComponent(ProductStore.dbName).path
                db = try Connection(dbPath)
                print("SQLiteDataStore init successfully at: \(dbPath) ")
                
                do {
                    try db?.scalar(products.exists)
                } catch {
                    createTable()
                }
                
            } catch {
                db = nil
                print("SQLiteDataStore init error: \(error)")
            }
        } else {
           db = nil
        }
    }
    
    private func createTable() {
        guard let database = db else {
            return
        }
        
        do {
            try database.run(
                products.create { table in
                    table.column(id, primaryKey: .autoincrement)
                    table.column(name)
                    table.column(price)
                    table.column(quantity)
                    table.column(ifBought)
            })
            print("SQLite table 'products' created")
        } catch {
            print("SQLite table creation error: \(error)")
        }
    }
    
    func insert(_ newProduct: ProductModel) -> Bool {
        guard let database = db else {
            return false
        }
        
        let insert = products.insert(
            self.name <- newProduct.name,
            self.price <- newProduct.price,
            self.quantity <- newProduct.quantity,
            self.ifBought <- newProduct.ifBought
        )
        
        do {
            try database.run(insert)
            print("SQLite product added")
            return true
        } catch {
            print("SQLite insert error: \(error)")
            return false
        }
    }
    
    func delete(id: Int64) -> Bool {
        guard let database = db else {
            return false
        }
        
        do {
            let filter = products.filter(self.id == id)
            try database.run(filter.delete())
            print("SQLite product (id:\(id)) deleted")
            return true
        } catch {
            print("SQLite delete error: \(error)")
            return false
        }
    }
    
    func getProducts() -> [ProductModel] {
        var productsFromDb: [ProductModel] = []
        
        guard let database = db else {
            return []
        }
        
        do {
            for product in try database.prepare(products) {
                productsFromDb.append(
                    ProductModel(
                        id: product[id],
                        name: product[name],
                        price: product[price],
                        quantity: product[quantity],
                        ifBought: product[ifBought]
                    )
                )
            }
        } catch {
            print("SQLite getting products from db failed: \(error)")
        }
        
        return productsFromDb
    }
    
    func update(updatedProduct: ProductModel) -> Bool {
        guard let database = db else {
            return false
        }
        
        let product = products.filter(self.id == updatedProduct.id)
        
        do {
            let update = product.update([
                self.name <- updatedProduct.name,
                self.price <- updatedProduct.price,
                self.quantity <- updatedProduct.quantity,
                self.ifBought <- updatedProduct.ifBought
            ])
            
            if try database.run(update) > 0 {
                return true
            }
        } catch {
            print("SQLite updating product (\(updatedProduct.id)) failed: \(error)")
        }
        return false
    }
    
}
