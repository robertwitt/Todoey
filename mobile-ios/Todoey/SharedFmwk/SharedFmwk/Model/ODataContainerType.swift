//
// Todoey
//
// Created by SAP BTP SDK Assistant for iOS v9.0.4 application on 14/02/23
//

import Foundation

public enum ODataContainerType: CaseIterable {
    case taskService
    case none

    public init?(rawValue: String) {
        guard let type = ODataContainerType.allCases.first(where: { rawValue == $0.description }) else {
            return nil
        }
        self = type
    }

    public var description: String {
        switch self {
        case .taskService: return "TaskService"
        case .none: return ""
        }
    }
}
