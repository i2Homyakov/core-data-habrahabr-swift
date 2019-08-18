//
//  Service+CoreDataClass.swift
//  core-data-habrahabr-swift
//
//  Created by Max Zasov on 18/08/2019.
//
//

import Foundation
import CoreData

@objc(Service)
public class Service: NSManagedObject {
    
    convenience init() {
        // Создание нового объекта
        self.init(context: CoreDataManager.instance.persistentContainer.viewContext)
    }
}
