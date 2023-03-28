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
        get {
            guard let color = color else {
                return nil
            }
            return UIColor(hexString: color)
        }
        set {
            var colorHex: String?
            
            if let color = newValue, let components = color.cgColor.components, components.count >= 3 {
                let r = Float(components[0])
                let g = Float(components[1])
                let b = Float(components[2])
                let a = Float(components.count >= 4 ? 1.0 : components[3])

                if a != Float(1.0) {
                    colorHex = String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
                } else {
                    colorHex = String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
                }
            }
            
            color = colorHex
        }
    }
    
    var isDefault: Bool? {
        return isDefault_
    }
    
    var isEditable: Bool {
        return true
    }
    
    func shouldList(task: Tasks) -> Bool {
        return task.collectionID == id
    }
    
    func newTask() -> Tasks {
        let task = Tasks(withDefaults: false)
        task.id = GuidValue.random()
        task.collectionID = id
        task.collection = self
        
        return task
    }
    
}
