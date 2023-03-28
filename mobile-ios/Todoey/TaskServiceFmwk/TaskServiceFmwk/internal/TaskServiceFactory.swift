// # Proxy Compiler 22.9.4

import Foundation
import SAPOData

internal enum TaskServiceFactory {
    static func registerAll() throws {
        TaskServiceMetadata.ComplexTypes.subTask.registerFactory(ObjectFactory.with(create: { SubTask(withDefaults: false) }, createWithDecoder: { d in try SubTask(from: d) }))
        TaskServiceMetadata.EntityTypes.taskCollections.registerFactory(ObjectFactory.with(create: { TaskCollections(withDefaults: false) }, sparse: { m in TaskCollections(withDefaults: false, withIndexMap: m) }, decode: { d in try TaskCollections(from: d) }))
        TaskServiceMetadata.EntityTypes.taskPriorities.registerFactory(ObjectFactory.with(create: { TaskPriorities(withDefaults: false) }, sparse: { m in TaskPriorities(withDefaults: false, withIndexMap: m) }, decode: { d in try TaskPriorities(from: d) }))
        TaskServiceMetadata.EntityTypes.taskPrioritiesTexts.registerFactory(ObjectFactory.with(create: { TaskPrioritiesTexts(withDefaults: false) }, sparse: { m in TaskPrioritiesTexts(withDefaults: false, withIndexMap: m) }, decode: { d in try TaskPrioritiesTexts(from: d) }))
        TaskServiceMetadata.EntityTypes.tasks.registerFactory(ObjectFactory.with(create: { Tasks(withDefaults: false) }, sparse: { m in Tasks(withDefaults: false, withIndexMap: m) }, decode: { d in try Tasks(from: d) }))
        TaskServiceStaticResolver.resolve()
    }
}
