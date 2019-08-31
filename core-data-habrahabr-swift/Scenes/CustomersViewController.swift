//
//  CustomersViewController.swift
//  core-data-habrahabr-swift
//
//  Created by Max Zasov on 24/08/2019.
//

import UIKit
import CoreData

class CustomersViewController: UITableViewController {
    
    typealias Select = (Customer?) -> ()
    
    // MARK: - Private constants

    private let customersToCustomerSegueId = "customersToCustomer"

    // MARK: - Properties
    
    var fetchedResultsController: NSFetchedResultsController<Customer> = CoreDataManager.instance.fetchedResultsController(keyForSort: "name")
    var didSelect: Select?

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
        performSegue(withIdentifier: customersToCustomerSegueId, sender: nil)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == customersToCustomerSegueId {
            guard let navigationController = segue.destination as? UINavigationController,
                let controller = navigationController.viewControllers.first as? CustomerViewController else {
                    fatalError("Could not get CustomerViewController")
            }
            controller.customer = sender as? Customer
        }
    }

    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customer = fetchedResultsController.object(at: indexPath)
        let cell = UITableViewCell()
        cell.textLabel?.text = customer.name
        return cell
    }

    // MARK: - Table View Delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let customer = fetchedResultsController.object(at: indexPath)
        if let dSelect = self.didSelect {
            dSelect(customer)
        } else {
            performSegue(withIdentifier: customersToCustomerSegueId, sender: customer)
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let managedObject = fetchedResultsController.object(at: indexPath)
            CoreDataManager.instance.persistentContainer.viewContext.delete(managedObject)
            CoreDataManager.instance.saveContext()
        }
    }
}

// MARK: - Fetched Results Controller Delegate

extension CustomersViewController: NSFetchedResultsControllerDelegate {

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
                let customer = fetchedResultsController.object(at: indexPath)
                let cell = tableView.cellForRow(at: indexPath)
                cell!.textLabel?.text = customer.name
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
