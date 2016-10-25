//
//  TravelerDashboardViewController.swift
//  GlobalWork
//
//  Created by naomi schettini on 2016-10-17.
//  Copyright © 2016 naomi schettini. All rights reserved.
//

import UIKit
import Firebase

class TravelerDashboardViewController: UIViewController,  UITableViewDelegate {

    let hosts:[User] = []
    
    
    //MARK : Properties
    
    var user: User!
    
    @IBOutlet var hostsAvailableTableView: UITableView!
    
    
    
    
    // MARK: UITableView Delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hosts.count
    }
    
    @nonobjc func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "travelerCell", for: indexPath)
        //        let groceryItem = items[indexPath.row]
        //
        //        cell.textLabel?.text = groceryItem.name
        //        cell.detailTextLabel?.text = groceryItem.addedByUser
        //
        //        toggleCellCheckbox(cell, isCompleted: groceryItem.completed)
        
        return cell
    }
    
    @objc(tableView:canFocusRowAtIndexPath:) func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //        if editingStyle == .delete {
        //            items.remove(at: indexPath.row)
        //            tableView.reloadData()
        //        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        //        var groceryItem = items[indexPath.row]
        //        let toggledCompletion = !groceryItem.completed
        //
        //        toggleCellCheckbox(cell, isCompleted: toggledCompletion)
        //        groceryItem.completed = toggledCompletion
        //        tableView.reloadData()
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
}

