//
//  TaskListTableViewModel.swift
//  Todoey
//
//  Created by Witt, Robert on 15.02.23.
//  Copyright © 2023 SAP. All rights reserved.
//

import Foundation
import SAPOData
import TaskServiceFmwk

class TaskListTableViewModel {
    
    private let taskService: TaskService<OnlineODataProvider>
    private var taskLists: [[TaskList]] = []
    
    init(taskService: TaskService<OnlineODataProvider>) {
        self.taskService = taskService
    }
    
    func reloadData(completionHandler: @escaping (Error?) -> Void) {
        taskLists = []
        
        let query = DataQuery()
            .select(TaskCollections.id, TaskCollections.title, TaskCollections.color, TaskCollections.isDefault_)
            .expand(TaskCollections.tasks, withQuery: DataQuery()
                .select(Tasks.id, Tasks.title, Tasks.dueTime, Tasks.dueTime, Tasks.isPlannedForMyDay)
                .expand(Tasks.collection, withQuery: DataQuery().select(TaskCollections.id, TaskCollections.title))
                .expand(Tasks.priority)
                .filter(Tasks.status.equal("O")))
        
        taskService.fetchTaskCollections(matching: query) { taskCollections, error in
            if error == nil {
                let allTasks = taskCollections?.flatMap { $0.tasks } ?? []
                self.taskLists = [
                    [TaskListView.myDay(tasks: allTasks), TaskListView.tomorrow(tasks: allTasks)],
                    taskCollections ?? []
                ]
            }
            completionHandler(error)
        }
    }
    
    var numberOfSections: Int {
        return taskLists.count
    }
    
    func numberOfObjects(inSection section: Int) -> Int {
        return taskLists[section].count
    }
    
    func object(at indexPath: IndexPath) -> TaskList {
        return taskLists[indexPath.section][indexPath.row]
    }
    
}

fileprivate enum Section: Int {
    case taskListViews = 0
    case taskCollections = 1
}

fileprivate enum TaskListViewRow: Int {
    case myDay = 0
    case tomorrow = 1
}
