//
//  Customer+CoreDataClass.swift
//  core-data-habrahabr-swift
//
//  Created by Max Zasov on 18/08/2019.
//
//

import Foundation
import CoreData

@objc(Customer)
public class Customer: NSManagedObject {

    convenience init() {
        // Создание нового объекта
        self.init(context: CoreDataManager.instance.persistentContainer.viewContext)
    }
}
