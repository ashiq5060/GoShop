//
//  CoreDataManager.swift
//  GoShop
//
//  Created by Ashiq P Paulose on 15/02/24.
//

import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {} // Singleton
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GoShop")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - CRUD Operations
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func createCartItem(productName: String, quantity: Int16, unitPrice: Double, imageUrl: String) {
        let context = persistentContainer.viewContext
        
        // Check if the product already exists in the cart
        if fetchCartItem(by: productName) != nil {
            // Product already exists, show alert and prevent adding
            AlertHelper.showAlert(withTitle: "GoShop", message: "This product is already in your cart.")
        } else {
            // Product doesn't exist, create a new entry
            let cartItem = Cart(context: context)
            cartItem.productName = productName
            cartItem.quantity = quantity
            cartItem.unitPrice = unitPrice
            cartItem.totalCost = unitPrice * Double(quantity)
            cartItem.imageUrl = imageUrl
            saveContext()
        }
    }
    
    func fetchCartItem(by productName: String) -> Cart? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Cart> = Cart.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "productName == %@", productName)
        
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("Error fetching cart item: \(error.localizedDescription)")
            return nil
        }
    }
    
    func fetchAllCartItems() -> [Cart] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Cart> = Cart.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching cart items: \(error.localizedDescription)")
            return []
        }
    }
    
    func updateCartItem(cartItem: Cart, quantity: Int16) {
        cartItem.quantity = quantity
        cartItem.totalCost = cartItem.unitPrice * Double(quantity)
        saveContext()
    }
    
    func deleteCartItem(cartItem: Cart) {
        let context = persistentContainer.viewContext
        context.delete(cartItem)
        saveContext()
    }
    
    func getCartItemCount() -> Int {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Cart> = Cart.fetchRequest()

        do {
            let itemCount = try context.count(for: fetchRequest)
            return itemCount
        } catch {
            print("Error fetching cart item count: \(error.localizedDescription)")
            return 0
        }
    }
    
    func getTotalCostOfCart() -> Double {
            let context = persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<Cart> = Cart.fetchRequest()
            
            do {
                let cartItems = try context.fetch(fetchRequest)
                let totalCost = cartItems.reduce(0.0) { $0 + $1.totalCost }
                return totalCost
            } catch {
                print("Error fetching cart items: \(error.localizedDescription)")
                return 0.0
            }
        }
    
}
