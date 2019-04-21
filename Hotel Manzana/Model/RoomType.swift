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
    var price: Int
}

extension RoomType: Equatable {
    static func == (left: RoomType, right: RoomType) -> Bool {
         return left.id == right.id
    }
}
