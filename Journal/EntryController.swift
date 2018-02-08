//
//  EntryController.swift
//  Journal
//
//  Created by Caleb Hicks on 10/1/15.
//  Copyright © 2015 DevMountain. All rights reserved.
//

import Foundation

class EntryController {
    
    static let shared = EntryController()
    
    func addEntryWith(title: String, bodyText: String) {
        Entry(title: title, bodyText: bodyText)
        saveToPersistentStorage()
    }
    
    func remove(entry: Entry) {
		CoreDataStack.context.delete(entry)
        saveToPersistentStorage()
    }
    
    func update(oldEntry: Entry, with title: String, bodyText: String) {
        oldEntry.title = title
        oldEntry.bodyText = bodyText
        saveToPersistentStorage()
    }
	
	// MARK: - Persistence
    
    private func saveToPersistentStorage() {
        do {
            try CoreDataStack.context.save()
        } catch  {
            print("error saving managed object context: \(error.localizedDescription)")
        }
    }
	
    
    
	// MARK: Properties
	
//    private(set) var entries = [Entry]()
}
