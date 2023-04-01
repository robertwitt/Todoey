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
    
    func newTask() -> Tasks {
        let task = Tasks(withDefaults: false)
        task.id = GuidValue.random()
        task.collectionID = id
        task.collection = self
        
        return task
    }
    
    func onTaskUpdated(_ task: TaskServiceFmwk.Tasks, postProcessor: TaskEditPostProcessing?) {
        let index = tasks.firstIndex { $0.id == task.id }
        
        if task.collectionID != id, let index = index {
            // Delete rows
            tasks.remove(at: index)
            postProcessor?.afterDelete(at: index)
        } else if let index = index {
            // Update row
            tasks[index] = task
                postProcessor?.afterUpdate(at: index)
        } else if task.collectionID == id {
            // Add row
            tasks.append(task)
            postProcessor?.afterInsert(at: tasks.count - 1)
        }
    }
    
    func onTaskRemoved(_ task: TaskServiceFmwk.Tasks, postProcessor: TaskEditPostProcessing?) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else {
            return
        }
        tasks.remove(at: index)
        postProcessor?.afterDelete(at: index)
    }
    
}
