//
//  OrderViewController.swift
//  core-data-habrahabr-swift
//
//  Created by Max Zasov on 25/08/2019.
//

import UIKit
import CoreData

class OrderViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var customerTextField: UITextField!
    @IBOutlet private weak var madeSwitch: UISwitch!
    @IBOutlet private weak var paidSwitch: UISwitch!
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Private constants
    
    private let orderToCustomersSegueId = "orderToCustomers"
    private let orderToRowOfOrderSegueId = "orderToRowOfOrder"
    
    // MARK: - Properties
    
    var order: Order?
    var table: NSFetchedResultsController<RowOfOrder>?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        setupStartData()
    }
    
    // MARK: - Setup
    
    private func setupStartData() {
        // Creating object
        if order == nil {
            order = Order()
            order?.date = NSDate()
        }
        
        // Reading object
        if let order = order {
            datePicker.date = order.date as Date? ?? Date()
            madeSwitch.isOn = order.made
            paidSwitch.isOn = order.paid
            customerTextField.text = order.customer?.name
            table = Order.getRowsOfOrder(order)
            table?.delegate = self
            
            do {
                try table?.performFetch()
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        saveOrder()
        dismiss(animated: true, completion: nil)
    }

    @IBAction func choiceCustomer(_ sender: Any)  {
        performSegue(withIdentifier: orderToCustomersSegueId, sender: nil)
    }
    
    @IBAction func addRowAction(_ sender: Any) {
        if let order = order {
            let newRowOfOrder = RowOfOrder()
            newRowOfOrder.order = order
            performSegue(withIdentifier: orderToRowOfOrderSegueId, sender: newRowOfOrder)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == orderToCustomersSegueId {
            guard let viewController = segue.destination as? CustomersViewController else {
                fatalError("Could not cast to CustomersViewController")
            }
            viewController.didSelect = { [unowned self] (customer) in
                if let customer = customer {
                    self.order?.customer = customer
                    self.customerTextField.text = customer.name
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else if segue.identifier == orderToRowOfOrderSegueId {
            guard let navigationController = segue.destination as? UINavigationController,
                let controller = navigationController.viewControllers.first as? RowOfOrderViewController else {
                    fatalError("Could not get RowOfOrderViewController")
            }
            controller.rowOfOrder = sender as? RowOfOrder
        }
    }
    
    // MARK: - Private functions
    
    private func saveOrder() {
        if let order = order {
            order.date = datePicker.date as NSDate
            order.made = madeSwitch.isOn
            order.paid = paidSwitch.isOn
            CoreDataManager.instance.saveContext()
        }
    }

    private func fillCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
        guard let table = table else {
            return
        }
        let rowOfOrder = table.object(at: indexPath)
        var nameOfService = "-- Unknown --"
        if let seviceName = rowOfOrder.service?.name {
            nameOfService = seviceName
        }
        cell.textLabel?.text = nameOfService + " - \(rowOfOrder.sum)"
    }
}

// MARK: - UITableViewDelegate

extension OrderViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commitEditingStyle editingStyle: UITableViewCell.EditingStyle, forRowAtIndexPath indexPath: IndexPath) {
        if let managedObject = table?.object(at: indexPath), editingStyle == .delete {
            CoreDataManager.instance.persistentContainer.viewContext.delete(managedObject)
            CoreDataManager.instance.saveContext()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowOfOrder = table?.object(at: indexPath)
        performSegue(withIdentifier: orderToRowOfOrderSegueId, sender: rowOfOrder)
    }
}

// MARK: - UITableViewDataSource

extension OrderViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return table?.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        fillCell(cell, at: indexPath)
        return cell
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension OrderViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) {
                fillCell(cell, at: indexPath)
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
