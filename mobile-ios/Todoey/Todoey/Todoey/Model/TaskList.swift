//
//  TaskList.swift
//  Todoey
//
//  Created by Witt, Robert on 15.02.23.
//  Copyright © 2023 SAP. All rights reserved.
//

import Foundation
import UIKit
import SAPOData
import TaskServiceFmwk

protocol TaskList {
    
    var ID: GuidValue? { get }
    var title: String? { get }
    var type: TaskListType { get }
    var displayColor: UIColor? { get }
    var isDefault: Bool? { get }
    var isEditable: Bool { get }
    var tasks: [Tasks] { get set }
    
    func shouldList(task: Tasks) -> Bool
    func newTask() -> Tasks
//    mutating func onTaskUpdated(_ task: Tasks, postProcessor: TaskEditPostProcessing?)
//    mutating func onTaskRemoved(_ task: Tasks, postProcessor: TaskEditPostProcessing?)
//    
}

extension TaskList {
    
    mutating func onTaskUpdated(_ task: Tasks, postProcessor: TaskEditPostProcessing?) {
        let index = tasks.firstIndex { $0.id == task.id }
        
        if !shouldList(task: task), let index = index {
            // Delete rows
            tasks.remove(at: index)
            DispatchQueue.main.async {
                postProcessor?.afterDelete(at: index)
            }
        } else if let index = index {
            // Update row
            tasks[index] = task
            DispatchQueue.main.async {
                postProcessor?.afterUpdate(at: index)
            }
        } else if shouldList(task: task) {
            // Add row
            tasks.append(task)
            let index = self.tasks.count - 1
            DispatchQueue.main.async {
                postProcessor?.afterInsert(at: index)
            }
        }
    }
    
    mutating func onTaskRemoved(_ task: Tasks, postProcessor: TaskEditPostProcessing?) {
        let index = tasks.firstIndex { $0.id == task.id }
        guard let index = index else {
            return
        }
        tasks.remove(at: index)
        postProcessor?.afterDelete(at: index)
    }
    
}

protocol TaskEditPostProcessing {
    func afterInsert(at rowIndex: Int)
    func afterUpdate(at rowIndex: Int)
    func afterDelete(at rowIndex: Int)
}

extension TaskEditPostProcessing {
    func afterInsert(at rowIndex: Int) {}
    func afterUpdate(at rowIndex: Int) {}
    func afterDelete(at rowIndex: Int) {}
}

enum TaskListType {
    case collection
    case myDay
    case tomorrow
}
