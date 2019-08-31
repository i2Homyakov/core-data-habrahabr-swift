//
//  RowOfOrderViewController.swift
//  core-data-habrahabr-swift
//
//  Created by Max Zasov on 31/08/2019.
//

import UIKit

class RowOfOrderViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var serviceTextField: UITextField!
    @IBOutlet private weak var sumTextField: UITextField!
    
    // MARK: - Private constants
    
    private let rowOfOrderToServicesSegueId = "rowOfOrderToServices"
    
    // MARK: - Properties
    
    var rowOfOrder: RowOfOrder?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let rowOfOrder = rowOfOrder {
            serviceTextField.text = rowOfOrder.service?.name
            sumTextField.text = String(rowOfOrder.sum)
        } else {
            rowOfOrder = RowOfOrder()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        saveRow()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func choiceServiceAction(_ sender: Any) {
        performSegue(withIdentifier: rowOfOrderToServicesSegueId, sender: nil)
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == rowOfOrderToServicesSegueId {
            guard let controller = segue.destination as? ServicesViewController else {
                fatalError("Could not cast to ServicesViewController")
            }

            controller.didSelect = { [unowned self] (service) in
                if let service = service {
                    self.rowOfOrder!.service = service
                    self.serviceTextField.text = service.name
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    // MARK: - Private functions
    
    func saveRow() {
        if let rowOfOrder = rowOfOrder {
            rowOfOrder.sum = Float(sumTextField.text ?? String()) ?? 0
            CoreDataManager.instance.saveContext()
        }
    }
}
