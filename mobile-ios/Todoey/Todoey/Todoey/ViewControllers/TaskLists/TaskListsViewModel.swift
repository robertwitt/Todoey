//
//  TaskListsViewModel.swift
//  Todoey
//
//  Created by Witt, Robert on 15.02.23.
//  Copyright © 2023 SAP. All rights reserved.
//

import Foundation
import SAPOData
import TaskServiceFmwk

class TaskListsViewModel {
    
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
                .select(Tasks.id, Tasks.title, Tasks.collectionID, Tasks.priorityCode, Tasks.dueDate, Tasks.dueTime, Tasks.isPlannedForMyDay, Tasks.lastModifiedAt, Tasks.subTasks)
                .expand(Tasks.collection, withQuery: DataQuery().select(TaskCollections.title))
                .expand(Tasks.priority, withQuery: DataQuery().select(TaskPriorities.name))
                .filter(Tasks.status.equal("O")))
        
        taskService.fetchTaskCollections(matching: query) { taskCollections, error in
            if error == nil {
                let allTasks = taskCollections?.flatMap { $0.tasks } ?? []
                self.taskLists = [
                    [TaskListView.myDay(tasks: allTasks), TaskListView.tomorrow(tasks: allTasks)],
                    taskCollections?.sorted(by: self.defaultThenAlphabetical(_:_:)) ?? []
                ]
            }
            completionHandler(error)
        }
    }
    
    func defaultThenAlphabetical(_ tc1: TaskCollections, _ tc2: TaskCollections) -> Bool {
        if let isDefault = tc1.isDefault_, isDefault {
            return true
        }
        if let isDefault = tc2.isDefault_, isDefault {
            return false
        }
        guard let title1 = tc1.title else {
            return false
        }
        guard let title2 = tc2.title else {
            return true
        }
        return title1 < title2
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
    
    func appendObject(_ collection: TaskCollections, completionHandler: @escaping (IndexPath?, Error?) -> Void) {
        taskService.createEntity(collection) { error in
            if error == nil {
                var collections = self.taskLists[Section.taskCollections.rawValue]
                collections.append(collection)
                self.taskLists[Section.taskCollections.rawValue] = collections
                let indexPath = IndexPath(row: collections.count - 1, section: Section.taskCollections.rawValue)
                completionHandler(indexPath, nil)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    func updateObject(_ collection: TaskCollections, completionHandler: @escaping (IndexPath?, Error?) -> Void) {
        taskService.updateEntity(collection) { error in
            if error == nil {
                var collections = self.taskLists[Section.taskCollections.rawValue]
                let index = collections.firstIndex { $0.ID == collection.id } ?? collections.count
                collections[index] = collection
                self.taskLists[Section.taskCollections.rawValue] = collections
                let indexPath = IndexPath(row: index, section: Section.taskCollections.rawValue)
                completionHandler(indexPath, nil)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    func removeObject(at indexPath: IndexPath, completionHandler: @escaping (Error?) -> Void) {
        guard let collection = object(at: indexPath) as? TaskCollections else {
            return
        }
        taskService.deleteEntity(collection) { error in
            if error == nil {
                var collections = self.taskLists[Section.taskCollections.rawValue]
                collections.remove(at: indexPath.row)
                self.taskLists[Section.taskCollections.rawValue] = collections
            }
            completionHandler(error)
        }
    }
    
    func setObjectAsDefault(_ object: TaskList, completionHandler: @escaping (IndexPath?, Error?) -> Void) {
        taskService.setDefaultTaskCollection(collectionID: object.ID) { error in
            if error == nil {
                self.reloadData { error in
                    if error == nil {
                        completionHandler(IndexPath(row: 0, section: Section.taskCollections.rawValue), nil)
                    } else {
                        completionHandler(nil, error)
                    }
                }
            } else {
                completionHandler(nil, error)
            }
        }
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
