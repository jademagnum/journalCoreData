//
//  CoreDataStack.swift
//  Journal
//
//  Created by Jade Thomason on 2/8/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import Foundation
import CoreData

enum CoreDataStack {
    static let container: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Journal")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    static var context: NSManagedObjectContext {
        return container.viewContext
    }
}
