//
// Todoey
//
// Created by SAP BTP SDK Assistant for iOS v9.0.4 application on 14/02/23
//

import Foundation

public enum TaskServiceCollectionType: CaseIterable {
    case taskPriorities
    case tasks
    case taskPrioritiesTexts
    case taskCollections

    public init?(rawValue: String) {
        guard let type = TaskServiceCollectionType.allCases.first(where: { rawValue == $0.description }) else {
            return nil
        }
        self = type
    }

    public var description: String {
        switch self {
        case .taskPriorities: return "TaskPriorities"
        case .tasks: return "Tasks"
        case .taskPrioritiesTexts: return "TaskPrioritiesTexts"
        case .taskCollections: return "TaskCollections"
        }
    }
}
