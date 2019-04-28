//
//  GuestsListTableViewController.swift
//  Hotel Manzana
//
//  Created by Ivan Nikitin on 25/04/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class GuestsListTableViewController: UITableViewController {
    
    var guestList = [Registration]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

// MARK: - Table view data source
extension GuestsListTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guestList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GuestCell", for: indexPath)
        let guest = guestList[indexPath.row]
        setupCell(cell, with: guest)
        
        return cell
    }
}

// MARK: - Custom Methods
extension GuestsListTableViewController {
    func setupCell(_ cell: UITableViewCell, with registration: Registration) {
        cell.textLabel?.text = registration.firstName
        cell.detailTextLabel?.text = "\(registration.totalCost)$"
    }
}

// MARK: - Navigation
extension GuestsListTableViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GuestRegistration" {
            let controller = segue.destination as! AddRegistrationTableViewController
            controller.delegate = self
        } else if segue.identifier == "DetailRegistrationSegue" {
            let controller = segue.destination as? DetailRegistrationTableViewController
            guard let indexPath = tableView.indexPathForSelectedRow?.row else { return }
            controller?.registration = guestList[indexPath]
        }
    }
}

// MARK: - SaveRegistrationProtocol
extension GuestsListTableViewController: SaveRegistrationProtocol {
    func saveRegistration(registration: Registration) {
        guestList.append(registration)
        tableView.reloadData()
    }
}

// MARK: - Table View Data Source
extension GuestsListTableViewController {
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "delete") { (action, indexPath) in
            let row = indexPath.row
            self.guestList.remove(at: row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        return [deleteAction]
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
