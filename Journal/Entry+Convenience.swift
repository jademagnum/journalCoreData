//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Jade Thomason on 2/8/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    
    @discardableResult convenience init(title: String, bodyText: String, timeStamp: Date = Date(), context: NSManagedObjectContext = CoreDataStack.context) {
        
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timeStamp = timeStamp
    }
}
