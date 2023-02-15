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

class TaskListView: TaskList {
    
    static let myDay = TaskListView(title: LocalizedStrings.Model.myDayTaskListView, type: .myDay)
    static let tomorrow = TaskListView(title: LocalizedStrings.Model.tomorrowTaskListView, type: .tomorrow)
    
    let ID: GuidValue? = nil
    let title: String?
    let type: TaskListType
    let displayColor: UIColor? = nil
    let isDefault: Bool? = false
    let isEditable = false
    
    private init(title: String?, type: TaskListType) {
        self.title = title
        self.type = type
    }
    
}
