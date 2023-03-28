//
//  LocalDate+Date.swift
//  Todoey
//
//  Created by Witt, Robert on 18.02.23.
//  Copyright © 2023 SAP. All rights reserved.
//

import Foundation
import SAPOData

extension LocalDate {
    
    static var tomorrow: LocalDate {
        return LocalDate.from(utc: Date.now.addingTimeInterval(86400))
    }
    
    var date: Date {
        let dateComponents = DateComponents(year: year, month: month, day: day)
        return Calendar.current.date(from: dateComponents)!
    }
    
}
