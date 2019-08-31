//
//  Customer+CoreDataProperties.swift
//  core-data-habrahabr-swift
//
//  Created by Max Zasov on 18/08/2019.
//
//

import Foundation
import CoreData


extension Customer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Customer> { // FIXME: возможно стоит выпилить и для других сущностей
        return NSFetchRequest<Customer>(entityName: Customer.entityName)
    }

    @NSManaged public var info: String?
    @NSManaged public var name: String?
    @NSManaged public var orders: NSSet?

}

// MARK: Generated accessors for orders
extension Customer {

    @objc(addOrdersObject:)
    @NSManaged public func addToOrders(_ value: Order)

    @objc(removeOrdersObject:)
    @NSManaged public func removeFromOrders(_ value: Order)

    @objc(addOrders:)
    @NSManaged public func addToOrders(_ values: NSSet)

    @objc(removeOrders:)
    @NSManaged public func removeFromOrders(_ values: NSSet)

}
