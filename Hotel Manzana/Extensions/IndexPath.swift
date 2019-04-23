//
//  IndexPath.swift
//  Hotel Manzana
//
//  Created by Ivan Nikitin on 23/04/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

extension IndexPath {
    var prevRow: IndexPath {
        let section = self.section
        let row = self.row - 1
        return IndexPath(row: row, section: section)
    }
}
