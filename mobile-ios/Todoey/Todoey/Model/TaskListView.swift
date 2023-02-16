//
//  TaskListView.swift
//  Todoey
//
//  Created by Witt, Robert on 15.02.23.
//  Copyright © 2023 SAP. All rights reserved.
//

import Foundation
import UIKit
import SAPOData
import TaskServiceFmwk

class TaskListView: TaskList {
    
    let ID: GuidValue? = nil
    let title: String?
    let type: TaskListType
    let displayColor: UIColor? = nil
    let isDefault: Bool? = false
    let isEditable = false
    let tasks: [Tasks]
    
    private init(title: String?, type: TaskListType, tasks: [Tasks]) {
        self.title = title
        self.type = type
        self.tasks = tasks
    }
    
    static func myDay(tasks: [Tasks]) -> TaskListView {
        let today = LocalDate.from(utc: Date.now)
        let myDayTasks = tasks.filter { task in
            if let isPlannedForMyDay = task.isPlannedForMyDay, isPlannedForMyDay {
                return true
            }
            guard let dueDate = task.dueDate else {
                return false
            }
            return dueDate <= today
        }
        
        return TaskListView(title: LocalizedStrings.Model.myDayTaskListView, type: .myDay, tasks: myDayTasks)
    }
    
    static func tomorrow(tasks: [Tasks]) -> TaskListView {
        let tomorrow = LocalDate.from(utc: Date.now.addingTimeInterval(86400))
        let tomorrowsTasks = tasks.filter{ $0.dueDate != nil && $0.dueDate! == tomorrow }
        return TaskListView(title: LocalizedStrings.Model.tomorrowTaskListView, type: .tomorrow, tasks: tomorrowsTasks)
    }
    
}
