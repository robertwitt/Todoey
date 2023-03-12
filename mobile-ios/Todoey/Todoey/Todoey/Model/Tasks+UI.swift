//
//  Tasks+UI.swift
//  Todoey
//
//  Created by Witt, Robert on 11.03.23.
//  Copyright © 2023 SAP. All rights reserved.
//

import UIKit
import SAPFiori
import TaskServiceFmwk

extension Tasks {
    
    var priorityIcon: UIImage {
        guard let priorityCode = priorityCode else {
            return UIImage()
        }
        switch priorityCode {
        case 1:
            return FUIIconLibrary.indicator.veryHighPriority
        case 3:
            return FUIIconLibrary.indicator.highPriority
        case 5:
            return FUIIconLibrary.indicator.mediumPriority
        default:
            return UIImage()
        }
    }
    
    var dueDateTime: Date? {
        guard let dueDate = dueDate else {
            return nil
        }
        let dateComponents = DateComponents(year: dueDate.year,
                                            month: dueDate.month,
                                            day: dueDate.day,
                                            hour: dueTime?.hour,
                                            minute: dueTime?.minute,
                                            second: dueTime?.second)
        return Calendar.current.date(from: dateComponents)
    }
    
    var formattedDueDateTime: String? {
        guard let dateTime = dueDateTime else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = dueTime != nil ? .short : .none
        return dateFormatter.string(from: dateTime)
    }
    
    var isOverdue: Bool {
        guard let dueDateTime = dueDateTime else {
            return false
        }
        return dueDateTime < Date.now
    }
    
}
