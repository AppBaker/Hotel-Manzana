//
//  RoomTypeTableViewController.swift
//  Hotel Manzana
//
//  Created by Ivan Nikitin on 24/04/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

protocol RoomTypeProtocol {
    func setRoomType(roomType: RoomType)
}

class RoomTypeTableViewController: UITableViewController {
    
    let rooms = RoomType.all
    var choosenRoomType: RoomType?
    var numberOfDays: Double?
    var delegate: RoomTypeProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Choose room type"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let choosenRoomType = choosenRoomType {
            tableView.cellForRow(at: IndexPath(row: choosenRoomType.id, section: 0))?.accessoryType = .checkmark
        }
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rooms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomTypeCell", for: indexPath)
        let room = rooms[indexPath.row]
        setupCell(cell, for: room)
        
        return cell
    }
}

// MARK: - Custom Methods
extension RoomTypeTableViewController {
    func setupCell(_ cell: UITableViewCell, for room: RoomType){
        if let numberOfDays = numberOfDays {
            let fullCost = numberOfDays * room.price
            cell.detailTextLabel?.text = "Total cost: \(fullCost.roundToCents())$"
        } else {
            cell.detailTextLabel?.text = "One day: \(room.price)$"
        }
        cell.textLabel?.text = room.name
    }
}

// MARK: - Table View Delegate
extension RoomTypeTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let choosenRoomType = choosenRoomType {
            if choosenRoomType.id == indexPath.row {
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            } else {
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                tableView.cellForRow(at: IndexPath(row: choosenRoomType.id, section: 0))?.accessoryType = .none
            }
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        let roomType = rooms[indexPath.row]
        choosenRoomType = roomType
        delegate?.setRoomType(roomType: roomType)
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Navigation
extension RoomTypeTableViewController {
    
}

