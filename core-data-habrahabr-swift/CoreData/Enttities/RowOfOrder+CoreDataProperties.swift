//
//  RowOfOrder+CoreDataProperties.swift
//  core-data-habrahabr-swift
//
//  Created by Max Zasov on 18/08/2019.
//
//

import Foundation
import CoreData


extension RowOfOrder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RowOfOrder> {
        return NSFetchRequest<RowOfOrder>(entityName: "RowOfOrder")
    }

    @NSManaged public var sum: Float
    @NSManaged public var order: Order?
    @NSManaged public var service: Service?

}
