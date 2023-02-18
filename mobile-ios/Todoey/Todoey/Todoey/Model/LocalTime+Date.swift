//
//  LocalTime+Date.swift
//  Todoey
//
//  Created by Witt, Robert on 18.02.23.
//  Copyright © 2023 SAP. All rights reserved.
//

import Foundation
import SAPOData

extension LocalTime {
    
    var date: Date {
        let dateComponents = DateComponents(hour: hour, minute: minute, second: second)
        return Calendar.current.date(from: dateComponents)!
    }
    
}
