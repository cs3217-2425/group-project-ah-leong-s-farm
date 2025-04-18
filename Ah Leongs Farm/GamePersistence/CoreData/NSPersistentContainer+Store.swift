//
//  NSPersistentContainer+Store.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 13/4/25.
//

import CoreData

extension NSPersistentContainer: Store {
    var managedContext: NSManagedObjectContext {
        viewContext
    }
}
