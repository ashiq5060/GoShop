//
//  Cart+CoreDataProperties.swift
//  GoShop
//
//  Created by Ashiq P Paulose on 15/02/24.
//
//

import Foundation
import CoreData


extension Cart {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cart> {
        return NSFetchRequest<Cart>(entityName: "Cart")
    }

    @NSManaged public var productName: String?
    @NSManaged public var quantity: Int16
    @NSManaged public var unitPrice: Double
    @NSManaged public var totalCost: Double
    @NSManaged public var imageUrl: String?

}

extension Cart : Identifiable {

}
