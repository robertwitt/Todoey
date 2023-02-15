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

protocol TaskList {
    
    var ID: GuidValue? { get }
    var title: String? { get }
    var type: TaskListType { get }
    var displayColor: UIColor? { get }
    var isDefault: Bool? { get }
    var isEditable: Bool { get }
    
}

enum TaskListType {
    case collection
    case myDay
    case tomorrow
}
