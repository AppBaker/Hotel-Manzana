//
//  RoomType.swift
//  Hotel Manzana
//
//  Created by Ivan Nikitin on 21/04/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

struct RoomType {
    var id: Int
    var name: String
    var shortName: String
    var price: Double
    
    static var all: [RoomType] {
        return [
        RoomType(id: 0, name: "Two Queens", shortName: "2Q", price: 179.34),
        RoomType(id: 1, name: "One King", shortName: "K", price: 209.23),
        RoomType(id: 2, name: "Penthouse Suite", shortName: "PHS", price: 309.17)
        ]
    }
}

extension RoomType: Equatable {
    static func == (left: RoomType, right: RoomType) -> Bool {
         return left.id == right.id
    }
}

