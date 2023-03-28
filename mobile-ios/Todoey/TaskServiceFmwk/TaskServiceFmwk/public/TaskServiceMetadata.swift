// # Proxy Compiler 22.9.4

import Foundation
import SAPOData

public enum TaskServiceMetadata {
    private static let document__lock = ObjectBase()

    private static var document_: CSDLDocument = TaskServiceMetadata.resolve()

    public static let lock: MetadataLock = xs_immortalize(MetadataLock())

    public static var document: CSDLDocument {
        get {
            objc_sync_enter(document__lock)
            defer { objc_sync_exit(document__lock) }
            do {
                return TaskServiceMetadata.document_
            }
        }
        set(value) {
            objc_sync_enter(document__lock)
            defer { objc_sync_exit(document__lock) }
            do {
                TaskServiceMetadata.document_ = value
            }
        }
    }

    private static func resolve() -> CSDLDocument {
        try! TaskServiceFactory.registerAll()
        TaskServiceMetadataParser.parsed.hasGeneratedProxies = true
        return TaskServiceMetadataParser.parsed.immortalize()
    }

    public enum ComplexTypes {
        private static let subTask__lock = ObjectBase()

        private static var subTask_: ComplexType = TaskServiceMetadataParser.parsed.complexType(withName: "TaskAPI.SubTask")

        public static var subTask: ComplexType {
            get {
                objc_sync_enter(subTask__lock)
                defer { objc_sync_exit(subTask__lock) }
                do {
                    return TaskServiceMetadata.ComplexTypes.subTask_
                }
            }
            set(value) {
                objc_sync_enter(subTask__lock)
                defer { objc_sync_exit(subTask__lock) }
                do {
                    TaskServiceMetadata.ComplexTypes.subTask_ = value
                }
            }
        }
    }

    public enum EntityTypes {
        private static let taskCollections__lock = ObjectBase()

        private static var taskCollections_: EntityType = TaskServiceMetadataParser.parsed.entityType(withName: "TaskAPI.TaskCollections")

        private static let taskPriorities__lock = ObjectBase()

        private static var taskPriorities_: EntityType = TaskServiceMetadataParser.parsed.entityType(withName: "TaskAPI.TaskPriorities")

        private static let taskPrioritiesTexts__lock = ObjectBase()

        private static var taskPrioritiesTexts_: EntityType = TaskServiceMetadataParser.parsed.entityType(withName: "TaskAPI.TaskPriorities_texts")

        private static let tasks__lock = ObjectBase()

        private static var tasks_: EntityType = TaskServiceMetadataParser.parsed.entityType(withName: "TaskAPI.Tasks")

        public static var taskCollections: EntityType {
            get {
                objc_sync_enter(taskCollections__lock)
                defer { objc_sync_exit(taskCollections__lock) }
                do {
                    return TaskServiceMetadata.EntityTypes.taskCollections_
                }
            }
            set(value) {
                objc_sync_enter(taskCollections__lock)
                defer { objc_sync_exit(taskCollections__lock) }
                do {
                    TaskServiceMetadata.EntityTypes.taskCollections_ = value
                }
            }
        }

        public static var taskPriorities: EntityType {
            get {
                objc_sync_enter(taskPriorities__lock)
                defer { objc_sync_exit(taskPriorities__lock) }
                do {
                    return TaskServiceMetadata.EntityTypes.taskPriorities_
                }
            }
            set(value) {
                objc_sync_enter(taskPriorities__lock)
                defer { objc_sync_exit(taskPriorities__lock) }
                do {
                    TaskServiceMetadata.EntityTypes.taskPriorities_ = value
                }
            }
        }

        public static var taskPrioritiesTexts: EntityType {
            get {
                objc_sync_enter(taskPrioritiesTexts__lock)
                defer { objc_sync_exit(taskPrioritiesTexts__lock) }
                do {
                    return TaskServiceMetadata.EntityTypes.taskPrioritiesTexts_
                }
            }
            set(value) {
                objc_sync_enter(taskPrioritiesTexts__lock)
                defer { objc_sync_exit(taskPrioritiesTexts__lock) }
                do {
                    TaskServiceMetadata.EntityTypes.taskPrioritiesTexts_ = value
                }
            }
        }

        public static var tasks: EntityType {
            get {
                objc_sync_enter(tasks__lock)
                defer { objc_sync_exit(tasks__lock) }
                do {
                    return TaskServiceMetadata.EntityTypes.tasks_
                }
            }
            set(value) {
                objc_sync_enter(tasks__lock)
                defer { objc_sync_exit(tasks__lock) }
                do {
                    TaskServiceMetadata.EntityTypes.tasks_ = value
                }
            }
        }
    }

    public enum EntitySets {
        private static let taskCollections__lock = ObjectBase()

        private static var taskCollections_: EntitySet = TaskServiceMetadataParser.parsed.entitySet(withName: "TaskCollections")

        private static let taskPriorities__lock = ObjectBase()

        private static var taskPriorities_: EntitySet = TaskServiceMetadataParser.parsed.entitySet(withName: "TaskPriorities")

        private static let taskPrioritiesTexts__lock = ObjectBase()

        private static var taskPrioritiesTexts_: EntitySet = TaskServiceMetadataParser.parsed.entitySet(withName: "TaskPriorities_texts")

        private static let tasks__lock = ObjectBase()

        private static var tasks_: EntitySet = TaskServiceMetadataParser.parsed.entitySet(withName: "Tasks")

        public static var taskCollections: EntitySet {
            get {
                objc_sync_enter(taskCollections__lock)
                defer { objc_sync_exit(taskCollections__lock) }
                do {
                    return TaskServiceMetadata.EntitySets.taskCollections_
                }
            }
            set(value) {
                objc_sync_enter(taskCollections__lock)
                defer { objc_sync_exit(taskCollections__lock) }
                do {
                    TaskServiceMetadata.EntitySets.taskCollections_ = value
                }
            }
        }

        public static var taskPriorities: EntitySet {
            get {
                objc_sync_enter(taskPriorities__lock)
                defer { objc_sync_exit(taskPriorities__lock) }
                do {
                    return TaskServiceMetadata.EntitySets.taskPriorities_
                }
            }
            set(value) {
                objc_sync_enter(taskPriorities__lock)
                defer { objc_sync_exit(taskPriorities__lock) }
                do {
                    TaskServiceMetadata.EntitySets.taskPriorities_ = value
                }
            }
        }

        public static var taskPrioritiesTexts: EntitySet {
            get {
                objc_sync_enter(taskPrioritiesTexts__lock)
                defer { objc_sync_exit(taskPrioritiesTexts__lock) }
                do {
                    return TaskServiceMetadata.EntitySets.taskPrioritiesTexts_
                }
            }
            set(value) {
                objc_sync_enter(taskPrioritiesTexts__lock)
                defer { objc_sync_exit(taskPrioritiesTexts__lock) }
                do {
                    TaskServiceMetadata.EntitySets.taskPrioritiesTexts_ = value
                }
            }
        }

        public static var tasks: EntitySet {
            get {
                objc_sync_enter(tasks__lock)
                defer { objc_sync_exit(tasks__lock) }
                do {
                    return TaskServiceMetadata.EntitySets.tasks_
                }
            }
            set(value) {
                objc_sync_enter(tasks__lock)
                defer { objc_sync_exit(tasks__lock) }
                do {
                    TaskServiceMetadata.EntitySets.tasks_ = value
                }
            }
        }
    }

    public enum Actions {
        private static let setDefaultTaskCollection__lock = ObjectBase()

        private static var setDefaultTaskCollection_: DataMethod = TaskServiceMetadataParser.parsed.dataMethod(withName: "TaskAPI.setDefaultTaskCollection")

        public static var setDefaultTaskCollection: DataMethod {
            get {
                objc_sync_enter(setDefaultTaskCollection__lock)
                defer { objc_sync_exit(setDefaultTaskCollection__lock) }
                do {
                    return TaskServiceMetadata.Actions.setDefaultTaskCollection_
                }
            }
            set(value) {
                objc_sync_enter(setDefaultTaskCollection__lock)
                defer { objc_sync_exit(setDefaultTaskCollection__lock) }
                do {
                    TaskServiceMetadata.Actions.setDefaultTaskCollection_ = value
                }
            }
        }
    }

    public enum Functions {
        private static let getDefaultTaskCollection__lock = ObjectBase()

        private static var getDefaultTaskCollection_: DataMethod = TaskServiceMetadataParser.parsed.dataMethod(withName: "TaskAPI.getDefaultTaskCollection")

        public static var getDefaultTaskCollection: DataMethod {
            get {
                objc_sync_enter(getDefaultTaskCollection__lock)
                defer { objc_sync_exit(getDefaultTaskCollection__lock) }
                do {
                    return TaskServiceMetadata.Functions.getDefaultTaskCollection_
                }
            }
            set(value) {
                objc_sync_enter(getDefaultTaskCollection__lock)
                defer { objc_sync_exit(getDefaultTaskCollection__lock) }
                do {
                    TaskServiceMetadata.Functions.getDefaultTaskCollection_ = value
                }
            }
        }
    }

    public enum BoundActions {
        private static let setToDone__lock = ObjectBase()

        private static var setToDone_: DataMethod = TaskServiceMetadataParser.parsed.dataMethod(withName: "TaskAPI.setToDone")

        public static var setToDone: DataMethod {
            get {
                objc_sync_enter(setToDone__lock)
                defer { objc_sync_exit(setToDone__lock) }
                do {
                    return TaskServiceMetadata.BoundActions.setToDone_
                }
            }
            set(value) {
                objc_sync_enter(setToDone__lock)
                defer { objc_sync_exit(setToDone__lock) }
                do {
                    TaskServiceMetadata.BoundActions.setToDone_ = value
                }
            }
        }
    }

    public enum ActionImports {
        private static let setDefaultTaskCollection__lock = ObjectBase()

        private static var setDefaultTaskCollection_: DataMethod = TaskServiceMetadataParser.parsed.dataMethod(withName: "setDefaultTaskCollection")

        public static var setDefaultTaskCollection: DataMethod {
            get {
                objc_sync_enter(setDefaultTaskCollection__lock)
                defer { objc_sync_exit(setDefaultTaskCollection__lock) }
                do {
                    return TaskServiceMetadata.ActionImports.setDefaultTaskCollection_
                }
            }
            set(value) {
                objc_sync_enter(setDefaultTaskCollection__lock)
                defer { objc_sync_exit(setDefaultTaskCollection__lock) }
                do {
                    TaskServiceMetadata.ActionImports.setDefaultTaskCollection_ = value
                }
            }
        }
    }

    public enum FunctionImports {
        private static let getDefaultTaskCollection__lock = ObjectBase()

        private static var getDefaultTaskCollection_: DataMethod = TaskServiceMetadataParser.parsed.dataMethod(withName: "getDefaultTaskCollection")

        public static var getDefaultTaskCollection: DataMethod {
            get {
                objc_sync_enter(getDefaultTaskCollection__lock)
                defer { objc_sync_exit(getDefaultTaskCollection__lock) }
                do {
                    return TaskServiceMetadata.FunctionImports.getDefaultTaskCollection_
                }
            }
            set(value) {
                objc_sync_enter(getDefaultTaskCollection__lock)
                defer { objc_sync_exit(getDefaultTaskCollection__lock) }
                do {
                    TaskServiceMetadata.FunctionImports.getDefaultTaskCollection_ = value
                }
            }
        }
    }
}
