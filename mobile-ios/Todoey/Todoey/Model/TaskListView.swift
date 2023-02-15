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
        // TODO Filter task collections and assign to view
        return TaskListView(title: LocalizedStrings.Model.myDayTaskListView, type: .myDay, tasks: tasks)
    }
    
    static func tomorrow(tasks: [Tasks]) -> TaskListView {
        // TODO Filter task collections and assign to view
        return TaskListView(title: LocalizedStrings.Model.tomorrowTaskListView, type: .tomorrow, tasks: tasks)
    }
    
}
