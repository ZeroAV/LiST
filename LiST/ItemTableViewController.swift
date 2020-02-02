//
//  ItemTableViewController.swift
//  LiST
//
//  Created by Aditya Alvari on 02/02/20.
//  Copyright © 2020 Aditya Alvari. All rights reserved.
//

import UIKit
import os.log

class ItemTableViewController: UITableViewController {
    var items = [Item]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        let savedItems = loadItems()

        if savedItems?.count ?? 0 > 0 {
            items = savedItems ?? [Item]()
        } else {
            loadSampleItems()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ItemTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ItemTableViewCell else{
            fatalError("The dequeued cell is not an instance of ItemTableViewCell")
        }
        let item = items[indexPath.row]
        cell.nameLabel.text = item.name
        cell.photoImageView.image = item.photo
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            items.remove(at: indexPath.row)
            saveItems()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? ""){
        case "AddItem":
            os_log("Adding a new item.", log: OSLog.default, type: .debug)
        case "ShowDetail":
            guard let itemDetailViewController = segue.destination as? ItemViewController else{
                fatalError("Unexpected destination \(segue.destination)")
            }
            guard let selectedItemCell = sender as? ItemTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            guard let indexPath = tableView.indexPath(for: selectedItemCell) else{
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedItem = items[indexPath.row]
            itemDetailViewController.item = selectedItem
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    

    private func loadSampleItems(){
        let photo1 = UIImage(named: "item1")
        let photo2 = UIImage(named: "item2")
        
        guard let item1 = Item(name: "Pencil", photo: photo1) else{
            fatalError("Unable to instantiate item1")
        }
        guard let item2 = Item(name: "iPad", photo: photo2) else{
            fatalError("Unable to instantiate item2")
        }
        
        items += [item1, item2]
    }
    
    private func saveItems(){
        let fullPath = getDocumentsDirectory().appendingPathComponent("items")

            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: items, requiringSecureCoding: false)
                try data.write(to: fullPath)
                os_log("Items successfully saved.", log: OSLog.default, type: .debug)
            } catch {
                os_log("Failed to save items...", log: OSLog.default, type: .error)
            }
        }

        func getDocumentsDirectory() -> URL {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            return paths[0]
        }

        private func loadItems() -> [Item]? {
            let fullPath = getDocumentsDirectory().appendingPathComponent("items")
            if let nsData = NSData(contentsOf: fullPath) {
                do {

                    let data = Data(referencing:nsData)

                    if let loadedItems = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Array<Item> {
                        return loadedItems
                    }
                } catch {
                    print("Couldn't read file.")
                    return nil
                }
            }
            return nil
    }

        

    @IBAction func unwindToItemList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ItemViewController, let item = sourceViewController.item{
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                items[selectedIndexPath.row] = item
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                //Add new item
                let newIndexPath = IndexPath(row: items.count, section: 0)
                items.append(item)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            saveItems()
        }
    }

    
}
