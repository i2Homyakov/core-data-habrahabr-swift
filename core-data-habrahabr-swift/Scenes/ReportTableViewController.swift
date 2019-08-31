//
//  ReportTableViewController.swift
//  core-data-habrahabr-swift
//
//  Created by Max Zasov on 31/08/2019.
//

import UIKit
import CoreData

class ReportTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var fetchRequest: NSFetchRequest<Order> = {
        var fetchRequest: NSFetchRequest<Order> = CoreDataManager.instance.makeFetchRequest()
        
        // Sort Descriptor
        let sortDescriptor1 = NSSortDescriptor(key: "date", ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: "customer.name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor1, sortDescriptor2]
        
        // Predicate
        let predicate = NSPredicate(format: "%K == %@ AND %K == %@", "made", NSNumber(value: true), "paid", NSNumber(value: false))
        fetchRequest.predicate = predicate
        
        return fetchRequest
    }()
    
    var report: [Order]?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            report = try CoreDataManager.instance.persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print(error)
        }
    }
    
    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let report = report {
            return report.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if let report = report {
            let order = report[indexPath.row]
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy"
            let nameOfCustomer = (order.customer == nil) ? "-- Unknown --" : (order.customer!.name!)
            cell.textLabel?.text = formatter.string(from: order.date as Date? ?? Date()) + "\t" + nameOfCustomer
        }
        
        return cell
    }
}
