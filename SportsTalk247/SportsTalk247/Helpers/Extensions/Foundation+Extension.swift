//
//  Foundation+Extension.swift
//  SportsTalk247
//
//  Created by Angelo Lesano on 2/4/21.
//  Copyright © 2021 krishna41. All rights reserved.
//

import Foundation

extension Date {
    func difference(between recent: Date, and earliest: Date) -> Int {
        return Int(recent.timeIntervalSince1970 - earliest.timeIntervalSince1970)
    }
}
