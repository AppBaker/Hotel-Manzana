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
}

// MARK: - Navigation
extension GuestsListTableViewController {
    @IBAction func unwindToGuestList(segue: UIStoryboardSegue){
        guard segue.identifier == "UnwindToGuestList" else { return }
        guard let container = segue.source as? AddRegistrationTableViewController else { return }
        if let registration = container.addRegistration {
            guestList.append(registration)
        }
    }
}
