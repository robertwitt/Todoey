//
//  TaskCollections+TaskList.swift
//  Todoey
//
//  Created by Witt, Robert on 15.02.23.
//  Copyright © 2023 SAP. All rights reserved.
//

import Foundation
import SAPOData
import TaskServiceFmwk

extension TaskCollections: TaskList {
    
    var ID: GuidValue? {
        return id
    }
    
    var type: TaskListType {
        return .collection
    }
    
    var displayColor: UIColor? {
        guard let color = color else {
            return nil
        }
        return UIColor(hexString: color)
    }
    
    var isDefault: Bool? {
        return isDefault_
    }
    
    var isEditable: Bool {
        return true
    }
    
}
