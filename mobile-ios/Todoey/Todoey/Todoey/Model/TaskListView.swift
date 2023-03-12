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
    var tasks: [Tasks]
    
    private init(title: String?, type: TaskListType, tasks: [Tasks]) {
        self.title = title
        self.type = type
        self.tasks = tasks
    }
    
    func shouldList(task: Tasks) -> Bool {
        switch (type) {
        case .myDay:
            return TaskListView.isTaskForMyDay(task)
        case .tomorrow:
            return TaskListView.isTaskForTomorrow(task)
        default:
            return false
        }
    }
    
    static func myDay(tasks: [Tasks]) -> TaskListView {
        let myDayTasks = tasks.filter { isTaskForMyDay($0) }
        return TaskListView(title: LocalizedStrings.Model.myDayTaskListView, type: .myDay, tasks: myDayTasks)
    }
    
    private static func isTaskForMyDay(_ task: Tasks) -> Bool {
        let today = LocalDate.from(utc: Date.now)
        if let isPlannedForMyDay = task.isPlannedForMyDay, isPlannedForMyDay {
            return true
        }
        guard let dueDate = task.dueDate else {
            return false
        }
        return dueDate <= today
    }
    
    static func tomorrow(tasks: [Tasks]) -> TaskListView {
        let tomorrowsTasks = tasks.filter{ isTaskForTomorrow($0) }
        return TaskListView(title: LocalizedStrings.Model.tomorrowTaskListView, type: .tomorrow, tasks: tomorrowsTasks)
    }
    
    private static func isTaskForTomorrow(_ task: Tasks) -> Bool {
        let tomorrow = LocalDate.from(utc: Date.now.addingTimeInterval(86400))
        return task.dueDate != nil && task.dueDate! == tomorrow
    }
    
}
