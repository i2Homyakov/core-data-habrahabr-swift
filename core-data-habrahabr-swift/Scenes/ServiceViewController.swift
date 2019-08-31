//
//  ServiceViewController.swift
//  core-data-habrahabr-swift
//
//  Created by Max Zasov on 25/08/2019.
//

import UIKit

class ServiceViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var infoTextField: UITextField!
    
    // MARK: - Properties
    
    var service: Service?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFields()
    }
    
    // MARK: - Setup
    
    private func setupFields() {
        // Reading object
        if let service = service {
            nameTextField.text = service.name
            infoTextField.text = service.info
        }
    }
    
    // MARK: - Actions
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        if saveService() {
            dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Private functions
    
    private func saveService() -> Bool {
        // Validation of required fields
        if nameTextField.text!.isEmpty {
            let alert = UIAlertController(title: "Validation error", message: "Input the name of the Service!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
        // Creating object
        if service == nil {
            service = Service()
        }
        // Saving object
        if let service = service {
            service.name = nameTextField.text
            service.info = infoTextField.text
            CoreDataManager.instance.saveContext()
        }
        return true
    }
}
