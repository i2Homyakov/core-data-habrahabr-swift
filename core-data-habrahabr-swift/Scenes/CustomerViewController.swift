//
//  CustomerViewController.swift
//  core-data-habrahabr-swift
//
//  Created by Max Zasov on 24/08/2019.
//

import UIKit

class CustomerViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var infoTextField: UITextField!

    // MARK: - Properties
    
    var customer: Customer?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFields()
    }
    
    // MARK: - Actions
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        if saveCustomer() {
            dismiss(animated: true, completion: nil)
        }
    }

    // MARK: - Setup

    private func setupFields() {
        // Reading object
        if let customer = customer {
            nameTextField.text = customer.name
            infoTextField.text = customer.info
        }
    }

    // MARK: - Private functions

    private func saveCustomer() -> Bool {
        // Validation of required fields
        if nameTextField.text!.isEmpty {
            let alert = UIAlertController(title: "Validation error", message: "Input the name of the Customer!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
        // Creating object
        if customer == nil {
            customer = Customer()
        }
        // Saving object
        if let customer = customer {
            customer.name = nameTextField.text
            customer.info = infoTextField.text
            CoreDataManager.instance.saveContext()
        }
        return true
    }
    
}
