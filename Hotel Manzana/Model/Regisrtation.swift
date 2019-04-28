//
//  Regisrtation.swift
//  Hotel Manzana
//
//  Created by Ivan Nikitin on 21/04/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

struct Registration {
    var firstName: String
    var lastNane: String
    var emailAdres: String
    
    var checkInDate: Date
    var checkOutDate: Date
    var numberOfAdults: Int
    var numberOfChildren: Int
    
    var roomType: RoomType
    var wifi: Bool
}

extension Registration {
    
    var totalCost: Double {
        let numberOfDays = checkOutDate.timeIntervalSince(checkInDate) / (60*60*24)
        var cost = numberOfDays * roomType.price
        if wifi {
            cost += numberOfDays * 9.99
        }
            return cost
    }
    var allKeys: [String] {
        return [
        "First name",
        "Last name",
        "E-mail",
        "Check in date",
        "Check out date",
        "Number of Adults",
        "Number of children",
        "Room Type",
        "Wi-Fi",
        ]
    }
    var allValues: [String] {
        let dateFormater = DateFormatter()
        dateFormater.timeStyle = .none
        dateFormater.dateStyle = .short
        return [
            firstName,
            lastNane,
            emailAdres,
            dateFormater.string(from: checkInDate),
            dateFormater.string(from: checkOutDate),
            "\(numberOfAdults)",
            "\(numberOfChildren)",
            roomType.shortName,
            "\(wifi)"
        ]
    }
}
