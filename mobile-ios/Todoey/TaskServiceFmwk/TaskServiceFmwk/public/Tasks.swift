// # Proxy Compiler 22.9.4

import Foundation
import SAPOData

open class Tasks: EntityValue {
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    private static let id__lock = ObjectBase()

    private static var id_: Property = TaskServiceMetadata.EntityTypes.tasks.property(withName: "ID")

    private static let title__lock = ObjectBase()

    private static var title_: Property = TaskServiceMetadata.EntityTypes.tasks.property(withName: "title")

    private static let collection__lock = ObjectBase()

    private static var collection_: Property = TaskServiceMetadata.EntityTypes.tasks.property(withName: "collection")

    private static let collectionID__lock = ObjectBase()

    private static var collectionID_: Property = TaskServiceMetadata.EntityTypes.tasks.property(withName: "collection_ID")

    private static let status__lock = ObjectBase()

    private static var status_: Property = TaskServiceMetadata.EntityTypes.tasks.property(withName: "status")

    private static let priority__lock = ObjectBase()

    private static var priority_: Property = TaskServiceMetadata.EntityTypes.tasks.property(withName: "priority")

    private static let priorityCode__lock = ObjectBase()

    private static var priorityCode_: Property = TaskServiceMetadata.EntityTypes.tasks.property(withName: "priority_code")

    private static let dueDate__lock = ObjectBase()

    private static var dueDate_: Property = TaskServiceMetadata.EntityTypes.tasks.property(withName: "dueDate")

    private static let dueTime__lock = ObjectBase()

    private static var dueTime_: Property = TaskServiceMetadata.EntityTypes.tasks.property(withName: "dueTime")

    private static let isPlannedForMyDay__lock = ObjectBase()

    private static var isPlannedForMyDay_: Property = TaskServiceMetadata.EntityTypes.tasks.property(withName: "isPlannedForMyDay")

    private static let subTasks__lock = ObjectBase()

    private static var subTasks_: Property = TaskServiceMetadata.EntityTypes.tasks.property(withName: "subTasks")

    private static let lastModifiedAt__lock = ObjectBase()

    private static var lastModifiedAt_: Property = TaskServiceMetadata.EntityTypes.tasks.property(withName: "lastModifiedAt")

    public init(withDefaults: Bool = true, withIndexMap: SparseIndexMap? = nil) {
        super.init(withDefaults: withDefaults, type: TaskServiceMetadata.EntityTypes.tasks, withIndexMap: withIndexMap)
    }

    open class func array(from: EntityValueList) -> [Tasks] {
        return ArrayConverter.convert(from.toArray(), [Tasks]())
    }

    open class var collection: Property {
        get {
            objc_sync_enter(collection__lock)
            defer { objc_sync_exit(collection__lock) }
            do {
                return Tasks.collection_
            }
        }
        set(value) {
            objc_sync_enter(collection__lock)
            defer { objc_sync_exit(collection__lock) }
            do {
                Tasks.collection_ = value
            }
        }
    }

    open var collection: TaskCollections? {
        get {
            return CastOptional<TaskCollections>.from(self.optionalValue(for: Tasks.collection))
        }
        set(value) {
            self.setOptionalValue(for: Tasks.collection, to: value)
        }
    }

    open class var collectionID: Property {
        get {
            objc_sync_enter(collectionID__lock)
            defer { objc_sync_exit(collectionID__lock) }
            do {
                return Tasks.collectionID_
            }
        }
        set(value) {
            objc_sync_enter(collectionID__lock)
            defer { objc_sync_exit(collectionID__lock) }
            do {
                Tasks.collectionID_ = value
            }
        }
    }

    open var collectionID: GuidValue? {
        get {
            return GuidValue.castOptional(self.optionalValue(for: Tasks.collectionID))
        }
        set(value) {
            self.setOptionalValue(for: Tasks.collectionID, to: value)
        }
    }

    open func copy() -> Tasks {
        return CastRequired<Tasks>.from(copyEntity())
    }

    open class var dueDate: Property {
        get {
            objc_sync_enter(dueDate__lock)
            defer { objc_sync_exit(dueDate__lock) }
            do {
                return Tasks.dueDate_
            }
        }
        set(value) {
            objc_sync_enter(dueDate__lock)
            defer { objc_sync_exit(dueDate__lock) }
            do {
                Tasks.dueDate_ = value
            }
        }
    }

    open var dueDate: LocalDate? {
        get {
            return LocalDate.castOptional(self.optionalValue(for: Tasks.dueDate))
        }
        set(value) {
            self.setOptionalValue(for: Tasks.dueDate, to: value)
        }
    }

    open class var dueTime: Property {
        get {
            objc_sync_enter(dueTime__lock)
            defer { objc_sync_exit(dueTime__lock) }
            do {
                return Tasks.dueTime_
            }
        }
        set(value) {
            objc_sync_enter(dueTime__lock)
            defer { objc_sync_exit(dueTime__lock) }
            do {
                Tasks.dueTime_ = value
            }
        }
    }

    open var dueTime: LocalTime? {
        get {
            return LocalTime.castOptional(self.optionalValue(for: Tasks.dueTime))
        }
        set(value) {
            self.setOptionalValue(for: Tasks.dueTime, to: value)
        }
    }

    open class var id: Property {
        get {
            objc_sync_enter(id__lock)
            defer { objc_sync_exit(id__lock) }
            do {
                return Tasks.id_
            }
        }
        set(value) {
            objc_sync_enter(id__lock)
            defer { objc_sync_exit(id__lock) }
            do {
                Tasks.id_ = value
            }
        }
    }

    open var id: GuidValue? {
        get {
            return GuidValue.castOptional(self.optionalValue(for: Tasks.id))
        }
        set(value) {
            self.setOptionalValue(for: Tasks.id, to: value)
        }
    }

    open class var isPlannedForMyDay: Property {
        get {
            objc_sync_enter(isPlannedForMyDay__lock)
            defer { objc_sync_exit(isPlannedForMyDay__lock) }
            do {
                return Tasks.isPlannedForMyDay_
            }
        }
        set(value) {
            objc_sync_enter(isPlannedForMyDay__lock)
            defer { objc_sync_exit(isPlannedForMyDay__lock) }
            do {
                Tasks.isPlannedForMyDay_ = value
            }
        }
    }

    open var isPlannedForMyDay: Bool? {
        get {
            return BooleanValue.optional(self.optionalValue(for: Tasks.isPlannedForMyDay))
        }
        set(value) {
            self.setOptionalValue(for: Tasks.isPlannedForMyDay, to: BooleanValue.of(optional: value))
        }
    }

    override open var isProxy: Bool {
        return true
    }

    open class func key(id: GuidValue?) -> EntityKey {
        return EntityKey().with(name: "ID", value: id)
    }

    open class var lastModifiedAt: Property {
        get {
            objc_sync_enter(lastModifiedAt__lock)
            defer { objc_sync_exit(lastModifiedAt__lock) }
            do {
                return Tasks.lastModifiedAt_
            }
        }
        set(value) {
            objc_sync_enter(lastModifiedAt__lock)
            defer { objc_sync_exit(lastModifiedAt__lock) }
            do {
                Tasks.lastModifiedAt_ = value
            }
        }
    }

    open var lastModifiedAt: GlobalDateTime? {
        get {
            return GlobalDateTime.castOptional(self.optionalValue(for: Tasks.lastModifiedAt))
        }
        set(value) {
            self.setOptionalValue(for: Tasks.lastModifiedAt, to: value)
        }
    }

    open var old: Tasks {
        return CastRequired<Tasks>.from(self.oldEntity)
    }

    open class var priority: Property {
        get {
            objc_sync_enter(priority__lock)
            defer { objc_sync_exit(priority__lock) }
            do {
                return Tasks.priority_
            }
        }
        set(value) {
            objc_sync_enter(priority__lock)
            defer { objc_sync_exit(priority__lock) }
            do {
                Tasks.priority_ = value
            }
        }
    }

    open var priority: TaskPriorities? {
        get {
            return CastOptional<TaskPriorities>.from(self.optionalValue(for: Tasks.priority))
        }
        set(value) {
            self.setOptionalValue(for: Tasks.priority, to: value)
        }
    }

    open class var priorityCode: Property {
        get {
            objc_sync_enter(priorityCode__lock)
            defer { objc_sync_exit(priorityCode__lock) }
            do {
                return Tasks.priorityCode_
            }
        }
        set(value) {
            objc_sync_enter(priorityCode__lock)
            defer { objc_sync_exit(priorityCode__lock) }
            do {
                Tasks.priorityCode_ = value
            }
        }
    }

    open var priorityCode: Int? {
        get {
            return UnsignedByte.optional(self.optionalValue(for: Tasks.priorityCode))
        }
        set(value) {
            self.setOptionalValue(for: Tasks.priorityCode, to: UnsignedByte.of(optional: value))
        }
    }

    open class var status: Property {
        get {
            objc_sync_enter(status__lock)
            defer { objc_sync_exit(status__lock) }
            do {
                return Tasks.status_
            }
        }
        set(value) {
            objc_sync_enter(status__lock)
            defer { objc_sync_exit(status__lock) }
            do {
                Tasks.status_ = value
            }
        }
    }

    open var status: String? {
        get {
            return StringValue.optional(self.optionalValue(for: Tasks.status))
        }
        set(value) {
            self.setOptionalValue(for: Tasks.status, to: StringValue.of(optional: value))
        }
    }

    open class var subTasks: Property {
        get {
            objc_sync_enter(subTasks__lock)
            defer { objc_sync_exit(subTasks__lock) }
            do {
                return Tasks.subTasks_
            }
        }
        set(value) {
            objc_sync_enter(subTasks__lock)
            defer { objc_sync_exit(subTasks__lock) }
            do {
                Tasks.subTasks_ = value
            }
        }
    }

    open var subTasks: [SubTask] {
        get {
            return ArrayConverter.convert(Tasks.subTasks.complexList(from: self).toArray(), [SubTask]())
        }
        set(value) {
            Tasks.subTasks.setComplexList(in: self, to: ComplexValueList.fromArray(ArrayConverter.convert(value, [ComplexValue]())))
        }
    }

    open class var title: Property {
        get {
            objc_sync_enter(title__lock)
            defer { objc_sync_exit(title__lock) }
            do {
                return Tasks.title_
            }
        }
        set(value) {
            objc_sync_enter(title__lock)
            defer { objc_sync_exit(title__lock) }
            do {
                Tasks.title_ = value
            }
        }
    }

    open var title: String? {
        get {
            return StringValue.optional(optionalValue(for: Tasks.title))
        }
        set(value) {
            setOptionalValue(for: Tasks.title, to: StringValue.of(optional: value))
        }
    }
}
