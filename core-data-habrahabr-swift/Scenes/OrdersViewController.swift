//
//  OrdersViewController.swift
//  core-data-habrahabr-swift
//
//  Created by Max Zasov on 25/08/2019.
//

import UIKit
import CoreData

class OrdersViewController: UITableViewController {
    
    // MARK: - Private constants
    
    private let ordersToOrderSegueId = "ordersToOrder"
    
    // MARK: - Properties
    
    var fetchedResultsController: NSFetchedResultsController<Order> = CoreDataManager.instance.fetchedResultsController(keyForSort: "date")
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
    }
    
    // MARK: - Action
    
    @IBAction func addAction(_ sender: AnyObject) {
        performSegue(withIdentifier: ordersToOrderSegueId, sender: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ordersToOrderSegueId {
            guard let navigationController = segue.destination as? UINavigationController,
                let controller = navigationController.viewControllers.first as? OrderViewController else {
                    fatalError("Could not get OrderViewController")
            }
            controller.order = sender as? Order
        }
    }
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let order = fetchedResultsController.object(at: indexPath)
        let cell = UITableViewCell()
        configCell(cell, order: order)
        return cell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ordersToOrderSegueId,
                     sender: fetchedResultsController.object(at: indexPath))
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let managedObject = fetchedResultsController.object(at: indexPath)
            CoreDataManager.instance.persistentContainer.viewContext.delete(managedObject)
            CoreDataManager.instance.saveContext()
        }
    }

    // MARK: - Private functions

    private func configCell(_ cell: UITableViewCell, order: Order) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        var nameOfCustomer = "-- Unknown --"
        
        if let customer = order.customer?.name {
            nameOfCustomer = customer
        }

        cell.textLabel?.text = formatter.string(from: order.date as Date? ?? Date()) + "\t" + nameOfCustomer
    }
}

// MARK: - Fetched Results Controller Delegate

extension OrdersViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                let order = fetchedResultsController.object(at: indexPath)
                let cell = tableView.cellForRow(at: indexPath)
                configCell(cell!, order: order)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        @unknown default:
            fatalError("Could not find NSFetchedResultsChangeType with rawValue: \(type.rawValue)")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}
