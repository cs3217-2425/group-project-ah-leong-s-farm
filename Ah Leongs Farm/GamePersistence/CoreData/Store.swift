//
//  Store.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 13/4/25.
//

import CoreData
import UIKit

protocol Store {
    var managedContext: NSManagedObjectContext { get }
}

extension Store {
    func save() throws {
        try managedContext.save()
    }

    func rollback() {
        managedContext.rollback()
    }

    func fetch<T: NSFetchRequestResult>(request: NSFetchRequest<T>) -> [T] {
        do {
            return try managedContext.fetch(request)
        } catch {
            return []
        }
    }
}
