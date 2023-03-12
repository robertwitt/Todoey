//
//  NotificationCenter.Name+Notifications.swift
//  Todoey
//
//  Created by Witt, Robert on 12.03.23.
//  Copyright © 2023 SAP. All rights reserved.
//

import Foundation

extension Notification.Name {
    
    static var taskUpdated: Notification.Name {
        return .init("Task.updated")
    }
    
    static var taskRemoved: Notification.Name {
        return .init("Task.removed")
    }
    
    static var taskListUpdated: Notification.Name {
        return .init("TaskList.updated")
    }
    
}
