// # Proxy Compiler 22.9.4

import Foundation
import SAPOData

open class TaskCollections: EntityValue {
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    private static let id__lock = ObjectBase()

    private static var id_: Property = TaskServiceMetadata.EntityTypes.taskCollections.property(withName: "ID")

    private static let title__lock = ObjectBase()

    private static var title_: Property = TaskServiceMetadata.EntityTypes.taskCollections.property(withName: "title")

    private static let color__lock = ObjectBase()

    private static var color_: Property = TaskServiceMetadata.EntityTypes.taskCollections.property(withName: "color")

    private static let isDefault___lock = ObjectBase()

    private static var isDefault__: Property = TaskServiceMetadata.EntityTypes.taskCollections.property(withName: "isDefault")

    private static let tasks__lock = ObjectBase()

    private static var tasks_: Property = TaskServiceMetadata.EntityTypes.taskCollections.property(withName: "tasks")

    public init(withDefaults: Bool = true, withIndexMap: SparseIndexMap? = nil) {
        super.init(withDefaults: withDefaults, type: TaskServiceMetadata.EntityTypes.taskCollections, withIndexMap: withIndexMap)
    }

    open class func array(from: EntityValueList) -> [TaskCollections] {
        return ArrayConverter.convert(from.toArray(), [TaskCollections]())
    }

    open class var color: Property {
        get {
            objc_sync_enter(color__lock)
            defer { objc_sync_exit(color__lock) }
            do {
                return TaskCollections.color_
            }
        }
        set(value) {
            objc_sync_enter(color__lock)
            defer { objc_sync_exit(color__lock) }
            do {
                TaskCollections.color_ = value
            }
        }
    }

    open var color: String? {
        get {
            return StringValue.optional(self.optionalValue(for: TaskCollections.color))
        }
        set(value) {
            self.setOptionalValue(for: TaskCollections.color, to: StringValue.of(optional: value))
        }
    }

    open func copy() -> TaskCollections {
        return CastRequired<TaskCollections>.from(copyEntity())
    }

    open class var id: Property {
        get {
            objc_sync_enter(id__lock)
            defer { objc_sync_exit(id__lock) }
            do {
                return TaskCollections.id_
            }
        }
        set(value) {
            objc_sync_enter(id__lock)
            defer { objc_sync_exit(id__lock) }
            do {
                TaskCollections.id_ = value
            }
        }
    }

    open var id: GuidValue? {
        get {
            return GuidValue.castOptional(self.optionalValue(for: TaskCollections.id))
        }
        set(value) {
            self.setOptionalValue(for: TaskCollections.id, to: value)
        }
    }

    open class var isDefault_: Property {
        get {
            objc_sync_enter(isDefault___lock)
            defer { objc_sync_exit(isDefault___lock) }
            do {
                return TaskCollections.isDefault__
            }
        }
        set(value) {
            objc_sync_enter(isDefault___lock)
            defer { objc_sync_exit(isDefault___lock) }
            do {
                TaskCollections.isDefault__ = value
            }
        }
    }

    open var isDefault_: Bool? {
        get {
            return BooleanValue.optional(self.optionalValue(for: TaskCollections.isDefault_))
        }
        set(value) {
            self.setOptionalValue(for: TaskCollections.isDefault_, to: BooleanValue.of(optional: value))
        }
    }

    override open var isProxy: Bool {
        return true
    }

    open class func key(id: GuidValue?) -> EntityKey {
        return EntityKey().with(name: "ID", value: id)
    }

    open var old: TaskCollections {
        return CastRequired<TaskCollections>.from(self.oldEntity)
    }

    open class var tasks: Property {
        get {
            objc_sync_enter(tasks__lock)
            defer { objc_sync_exit(tasks__lock) }
            do {
                return TaskCollections.tasks_
            }
        }
        set(value) {
            objc_sync_enter(tasks__lock)
            defer { objc_sync_exit(tasks__lock) }
            do {
                TaskCollections.tasks_ = value
            }
        }
    }

    open var tasks: [Tasks] {
        get {
            return ArrayConverter.convert(TaskCollections.tasks.entityList(from: self).toArray(), [Tasks]())
        }
        set(value) {
            TaskCollections.tasks.setEntityList(in: self, to: EntityValueList.fromArray(ArrayConverter.convert(value, [EntityValue]())))
        }
    }

    open class var title: Property {
        get {
            objc_sync_enter(title__lock)
            defer { objc_sync_exit(title__lock) }
            do {
                return TaskCollections.title_
            }
        }
        set(value) {
            objc_sync_enter(title__lock)
            defer { objc_sync_exit(title__lock) }
            do {
                TaskCollections.title_ = value
            }
        }
    }

    open var title: String? {
        get {
            return StringValue.optional(optionalValue(for: TaskCollections.title))
        }
        set(value) {
            setOptionalValue(for: TaskCollections.title, to: StringValue.of(optional: value))
        }
    }
}
