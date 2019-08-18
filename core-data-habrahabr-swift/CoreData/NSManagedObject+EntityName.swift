//
//  NSManagedObject+EntityName.swift
//  core-data-habrahabr-swift
//
//  Created by Max Zasov on 18/08/2019.
//

import Foundation
import CoreData

extension NSManagedObject {
    static var entityName: String {
        return "\(self)"
    }
}
