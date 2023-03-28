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
    
}

enum TaskListType {
    case collection
    case myDay
    case tomorrow
}
