//
//  DetailRegistrationTableViewController.swift
//  Hotel Manzana
//
//  Created by Ivan Nikitin on 28/04/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class DetailRegistrationTableViewController: UITableViewController {
    
    var registration: Registration?
    var keys = [String]()
    var values = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        if let registration = registration {
            keys = registration.allKeys
            values = registration.allValues
            title = "Cost: \(registration.totalCost.roundToCents())$"
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return registration?.allKeys.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailRegistration", for: indexPath)
        cell.textLabel?.text = keys[indexPath.row]
        cell.detailTextLabel?.text = values[indexPath.row]
        return cell
    }
 
}
