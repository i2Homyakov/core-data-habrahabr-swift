//
//  Order+CoreDataClass.swift
//  core-data-habrahabr-swift
//
//  Created by Max Zasov on 18/08/2019.
//
//

import Foundation
import CoreData

@objc(Order)
public class Order: NSManagedObject {
    
    convenience init() {
        // Создание нового объекта
        self.init(context: CoreDataManager.instance.persistentContainer.viewContext)
    }
    
    // MARK: - Public
    
    class func getRowsOfOrder(_ order: Order) -> NSFetchedResultsController<RowOfOrder> {
        
        let fetchRequest: NSFetchRequest<RowOfOrder> = CoreDataManager.instance.makeFetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "service.name", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "%K == %@", "order", order)
        
        return NSFetchedResultsController(fetchRequest: fetchRequest,
                                          managedObjectContext: CoreDataManager.instance.persistentContainer.viewContext,
                                          sectionNameKeyPath: nil, cacheName: nil)
    }
}
