//
//  Double.swift
//  Hotel Manzana
//
//  Created by Ivan Nikitin on 24/04/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

extension Double {
    func roundToCents() -> String {
        if self.rounded() == self {
            return String(Int(self))
        }
        return String((self*100).rounded() / 100)
    }
}
