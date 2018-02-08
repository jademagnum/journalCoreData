//
//  ListTableViewController.swift
//  Journal
//
//  Created by Caleb Hicks on 10/3/15.
//  Copyright © 2015 DevMountain. All rights reserved.
//

import UIKit
import CoreData

class EntryListTableViewController: UITableViewController {
	
    let fetchedResultsController: NSFetchedResultsController<Entry> = {
    
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("error performing initial fetch for fetched results controller: \(error.localizedDescription)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: UITableViewDataSource/Delegate

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)

        let entry = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = entry.title

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		
		if editingStyle == .delete {
        
            let entry = fetchedResultsController.object(at: indexPath)
			EntryController.shared.remove(entry: entry)
			
        }
    }
	
	// MARK: Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "toShowEntry" {
            
            if let detailViewController = segue.destination as? EntryDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                
                    let entry = fetchedResultsController.object(at: indexPath)
                    detailViewController.entry = entry
            }
        }
    }
}

extension EntryListTableViewController: NSFetchedResultsControllerDelegate {
    
    //MARK: - NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller:
        NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        case .move:
            guard let indexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
            
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
    }
    
    func controller(_ controller:
        NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        
        switch type {
            
        case .insert:
            
            let indexSet = IndexSet(integer: sectionIndex)
            
            tableView.insertSections(indexSet, with: .automatic)
            
        case .delete:
            
            let indexSet = IndexSet(integer: sectionIndex)
            
            tableView.deleteSections(indexSet, with: .fade)
            
        default:
            break
        }
    }
}



















