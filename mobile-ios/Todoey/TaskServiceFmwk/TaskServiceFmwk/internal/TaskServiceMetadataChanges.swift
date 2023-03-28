// # Proxy Compiler 22.9.4

import Foundation
import SAPOData

internal enum TaskServiceMetadataChanges {
    static func merge(metadata: CSDLDocument) {
        metadata.hasGeneratedProxies = true
        TaskServiceMetadata.document = metadata
        TaskServiceMetadataChanges.merge1(metadata: metadata)
        try! TaskServiceFactory.registerAll()
    }

    private static func merge1(metadata: CSDLDocument) {
        _ = metadata
        if !TaskServiceMetadata.ComplexTypes.subTask.isRemoved {
            TaskServiceMetadata.ComplexTypes.subTask = metadata.complexType(withName: "TaskAPI.SubTask")
        }
        if !TaskServiceMetadata.EntityTypes.taskCollections.isRemoved {
            TaskServiceMetadata.EntityTypes.taskCollections = metadata.entityType(withName: "TaskAPI.TaskCollections")
        }
        if !TaskServiceMetadata.EntityTypes.taskPriorities.isRemoved {
            TaskServiceMetadata.EntityTypes.taskPriorities = metadata.entityType(withName: "TaskAPI.TaskPriorities")
        }
        if !TaskServiceMetadata.EntityTypes.taskPrioritiesTexts.isRemoved {
            TaskServiceMetadata.EntityTypes.taskPrioritiesTexts = metadata.entityType(withName: "TaskAPI.TaskPriorities_texts")
        }
        if !TaskServiceMetadata.EntityTypes.tasks.isRemoved {
            TaskServiceMetadata.EntityTypes.tasks = metadata.entityType(withName: "TaskAPI.Tasks")
        }
        if !TaskServiceMetadata.EntitySets.taskCollections.isRemoved {
            TaskServiceMetadata.EntitySets.taskCollections = metadata.entitySet(withName: "TaskCollections")
        }
        if !TaskServiceMetadata.EntitySets.taskPriorities.isRemoved {
            TaskServiceMetadata.EntitySets.taskPriorities = metadata.entitySet(withName: "TaskPriorities")
        }
        if !TaskServiceMetadata.EntitySets.taskPrioritiesTexts.isRemoved {
            TaskServiceMetadata.EntitySets.taskPrioritiesTexts = metadata.entitySet(withName: "TaskPriorities_texts")
        }
        if !TaskServiceMetadata.EntitySets.tasks.isRemoved {
            TaskServiceMetadata.EntitySets.tasks = metadata.entitySet(withName: "Tasks")
        }
        if !TaskServiceMetadata.Actions.setDefaultTaskCollection.isRemoved {
            TaskServiceMetadata.Actions.setDefaultTaskCollection = metadata.dataMethod(withName: "TaskAPI.setDefaultTaskCollection")
        }
        if !TaskServiceMetadata.Functions.getDefaultTaskCollection.isRemoved {
            TaskServiceMetadata.Functions.getDefaultTaskCollection = metadata.dataMethod(withName: "TaskAPI.getDefaultTaskCollection")
        }
        if !TaskServiceMetadata.BoundActions.setToDone.isRemoved {
            TaskServiceMetadata.BoundActions.setToDone = metadata.dataMethod(withName: "TaskAPI.setToDone")
        }
        if !TaskServiceMetadata.ActionImports.setDefaultTaskCollection.isRemoved {
            TaskServiceMetadata.ActionImports.setDefaultTaskCollection = metadata.dataMethod(withName: "setDefaultTaskCollection")
        }
        if !TaskServiceMetadata.FunctionImports.getDefaultTaskCollection.isRemoved {
            TaskServiceMetadata.FunctionImports.getDefaultTaskCollection = metadata.dataMethod(withName: "getDefaultTaskCollection")
        }
        if !SubTask.title.isRemoved {
            SubTask.title = TaskServiceMetadata.ComplexTypes.subTask.property(withName: "title")
        }
        if !SubTask.isDone.isRemoved {
            SubTask.isDone = TaskServiceMetadata.ComplexTypes.subTask.property(withName: "isDone")
        }
        if !TaskCollections.id.isRemoved {
            TaskCollections.id = TaskServiceMetadata.EntityTypes.taskCollections.property(withName: "ID")
        }
        if !TaskCollections.title.isRemoved {
            TaskCollections.title = TaskServiceMetadata.EntityTypes.taskCollections.property(withName: "title")
        }
        if !TaskCollections.color.isRemoved {
            TaskCollections.color = TaskServiceMetadata.EntityTypes.taskCollections.property(withName: "color")
        }
        if !TaskCollections.isDefault_.isRemoved {
            TaskCollections.isDefault_ = TaskServiceMetadata.EntityTypes.taskCollections.property(withName: "isDefault")
        }
        if !TaskCollections.tasks.isRemoved {
            TaskCollections.tasks = TaskServiceMetadata.EntityTypes.taskCollections.property(withName: "tasks")
        }
        if !TaskPriorities.name.isRemoved {
            TaskPriorities.name = TaskServiceMetadata.EntityTypes.taskPriorities.property(withName: "name")
        }
        if !TaskPriorities.code.isRemoved {
            TaskPriorities.code = TaskServiceMetadata.EntityTypes.taskPriorities.property(withName: "code")
        }
        if !TaskPriorities.texts.isRemoved {
            TaskPriorities.texts = TaskServiceMetadata.EntityTypes.taskPriorities.property(withName: "texts")
        }
        if !TaskPriorities.localized.isRemoved {
            TaskPriorities.localized = TaskServiceMetadata.EntityTypes.taskPriorities.property(withName: "localized")
        }
        if !TaskPrioritiesTexts.locale.isRemoved {
            TaskPrioritiesTexts.locale = TaskServiceMetadata.EntityTypes.taskPrioritiesTexts.property(withName: "locale")
        }
        if !TaskPrioritiesTexts.name.isRemoved {
            TaskPrioritiesTexts.name = TaskServiceMetadata.EntityTypes.taskPrioritiesTexts.property(withName: "name")
        }
        if !TaskPrioritiesTexts.descr.isRemoved {
            TaskPrioritiesTexts.descr = TaskServiceMetadata.EntityTypes.taskPrioritiesTexts.property(withName: "descr")
        }
        if !TaskPrioritiesTexts.code.isRemoved {
            TaskPrioritiesTexts.code = TaskServiceMetadata.EntityTypes.taskPrioritiesTexts.property(withName: "code")
        }
        if !Tasks.id.isRemoved {
            Tasks.id = TaskServiceMetadata.EntityTypes.tasks.property(withName: "ID")
        }
        if !Tasks.title.isRemoved {
            Tasks.title = TaskServiceMetadata.EntityTypes.tasks.property(withName: "title")
        }
        if !Tasks.collection.isRemoved {
            Tasks.collection = TaskServiceMetadata.EntityTypes.tasks.property(withName: "collection")
        }
        if !Tasks.collectionID.isRemoved {
            Tasks.collectionID = TaskServiceMetadata.EntityTypes.tasks.property(withName: "collection_ID")
        }
        if !Tasks.status.isRemoved {
            Tasks.status = TaskServiceMetadata.EntityTypes.tasks.property(withName: "status")
        }
        if !Tasks.priority.isRemoved {
            Tasks.priority = TaskServiceMetadata.EntityTypes.tasks.property(withName: "priority")
        }
        if !Tasks.priorityCode.isRemoved {
            Tasks.priorityCode = TaskServiceMetadata.EntityTypes.tasks.property(withName: "priority_code")
        }
        if !Tasks.dueDate.isRemoved {
            Tasks.dueDate = TaskServiceMetadata.EntityTypes.tasks.property(withName: "dueDate")
        }
        if !Tasks.dueTime.isRemoved {
            Tasks.dueTime = TaskServiceMetadata.EntityTypes.tasks.property(withName: "dueTime")
        }
        if !Tasks.isPlannedForMyDay.isRemoved {
            Tasks.isPlannedForMyDay = TaskServiceMetadata.EntityTypes.tasks.property(withName: "isPlannedForMyDay")
        }
        if !Tasks.subTasks.isRemoved {
            Tasks.subTasks = TaskServiceMetadata.EntityTypes.tasks.property(withName: "subTasks")
        }
        if !Tasks.lastModifiedAt.isRemoved {
            Tasks.lastModifiedAt = TaskServiceMetadata.EntityTypes.tasks.property(withName: "lastModifiedAt")
        }
    }
}
