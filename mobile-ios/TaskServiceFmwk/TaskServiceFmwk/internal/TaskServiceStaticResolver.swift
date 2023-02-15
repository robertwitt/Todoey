// # Proxy Compiler 22.9.4

import Foundation
import SAPOData

internal enum TaskServiceStaticResolver {
    static func resolve() {
        TaskServiceStaticResolver.resolve1()
    }

    private static func resolve1() {
        _ = TaskServiceMetadata.EntityTypes.taskCollections
        _ = TaskServiceMetadata.EntityTypes.taskPriorities
        _ = TaskServiceMetadata.EntityTypes.taskPrioritiesTexts
        _ = TaskServiceMetadata.EntityTypes.tasks
        _ = TaskServiceMetadata.EntitySets.taskCollections
        _ = TaskServiceMetadata.EntitySets.taskPriorities
        _ = TaskServiceMetadata.EntitySets.taskPrioritiesTexts
        _ = TaskServiceMetadata.EntitySets.tasks
        _ = TaskServiceMetadata.Actions.setDefaultTaskCollection
        _ = TaskServiceMetadata.Functions.getDefaultTaskCollection
        _ = TaskServiceMetadata.BoundActions.setToDone
        _ = TaskServiceMetadata.ActionImports.setDefaultTaskCollection
        _ = TaskServiceMetadata.FunctionImports.getDefaultTaskCollection
        _ = TaskCollections.id
        _ = TaskCollections.title
        _ = TaskCollections.color
        _ = TaskCollections.isDefault_
        _ = TaskCollections.tasks
        _ = TaskPriorities.name
        _ = TaskPriorities.code
        _ = TaskPriorities.texts
        _ = TaskPriorities.localized
        _ = TaskPrioritiesTexts.locale
        _ = TaskPrioritiesTexts.name
        _ = TaskPrioritiesTexts.descr
        _ = TaskPrioritiesTexts.code
        _ = Tasks.id
        _ = Tasks.title
        _ = Tasks.collection
        _ = Tasks.collectionID
        _ = Tasks.status
        _ = Tasks.priority
        _ = Tasks.priorityCode
        _ = Tasks.dueDate
        _ = Tasks.dueTime
        _ = Tasks.isPlannedForMyDay
        _ = Tasks.lastModifiedAt
    }
}
