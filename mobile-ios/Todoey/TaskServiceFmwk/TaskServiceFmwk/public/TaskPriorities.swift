// # Proxy Compiler 22.9.4

import Foundation
import SAPOData

open class TaskPriorities: EntityValue {
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    private static let name__lock = ObjectBase()

    private static var name_: Property = TaskServiceMetadata.EntityTypes.taskPriorities.property(withName: "name")

    private static let code__lock = ObjectBase()

    private static var code_: Property = TaskServiceMetadata.EntityTypes.taskPriorities.property(withName: "code")

    private static let texts__lock = ObjectBase()

    private static var texts_: Property = TaskServiceMetadata.EntityTypes.taskPriorities.property(withName: "texts")

    private static let localized__lock = ObjectBase()

    private static var localized_: Property = TaskServiceMetadata.EntityTypes.taskPriorities.property(withName: "localized")

    public init(withDefaults: Bool = true, withIndexMap: SparseIndexMap? = nil) {
        super.init(withDefaults: withDefaults, type: TaskServiceMetadata.EntityTypes.taskPriorities, withIndexMap: withIndexMap)
    }

    open class func array(from: EntityValueList) -> [TaskPriorities] {
        return ArrayConverter.convert(from.toArray(), [TaskPriorities]())
    }

    open class var code: Property {
        get {
            objc_sync_enter(code__lock)
            defer { objc_sync_exit(code__lock) }
            do {
                return TaskPriorities.code_
            }
        }
        set(value) {
            objc_sync_enter(code__lock)
            defer { objc_sync_exit(code__lock) }
            do {
                TaskPriorities.code_ = value
            }
        }
    }

    open var code: Int? {
        get {
            return UnsignedByte.optional(self.optionalValue(for: TaskPriorities.code))
        }
        set(value) {
            self.setOptionalValue(for: TaskPriorities.code, to: UnsignedByte.of(optional: value))
        }
    }

    open func copy() -> TaskPriorities {
        return CastRequired<TaskPriorities>.from(copyEntity())
    }

    override open var isProxy: Bool {
        return true
    }

    open class func key(code: Int?) -> EntityKey {
        return EntityKey().with(name: "code", value: UnsignedByte.of(optional: code))
    }

    open class var localized: Property {
        get {
            objc_sync_enter(localized__lock)
            defer { objc_sync_exit(localized__lock) }
            do {
                return TaskPriorities.localized_
            }
        }
        set(value) {
            objc_sync_enter(localized__lock)
            defer { objc_sync_exit(localized__lock) }
            do {
                TaskPriorities.localized_ = value
            }
        }
    }

    open var localized: TaskPrioritiesTexts? {
        get {
            return CastOptional<TaskPrioritiesTexts>.from(self.optionalValue(for: TaskPriorities.localized))
        }
        set(value) {
            self.setOptionalValue(for: TaskPriorities.localized, to: value)
        }
    }

    open class var name: Property {
        get {
            objc_sync_enter(name__lock)
            defer { objc_sync_exit(name__lock) }
            do {
                return TaskPriorities.name_
            }
        }
        set(value) {
            objc_sync_enter(name__lock)
            defer { objc_sync_exit(name__lock) }
            do {
                TaskPriorities.name_ = value
            }
        }
    }

    open var name: String? {
        get {
            return StringValue.optional(self.optionalValue(for: TaskPriorities.name))
        }
        set(value) {
            self.setOptionalValue(for: TaskPriorities.name, to: StringValue.of(optional: value))
        }
    }

    open var old: TaskPriorities {
        return CastRequired<TaskPriorities>.from(self.oldEntity)
    }

    open class var texts: Property {
        get {
            objc_sync_enter(texts__lock)
            defer { objc_sync_exit(texts__lock) }
            do {
                return TaskPriorities.texts_
            }
        }
        set(value) {
            objc_sync_enter(texts__lock)
            defer { objc_sync_exit(texts__lock) }
            do {
                TaskPriorities.texts_ = value
            }
        }
    }

    open var texts: [TaskPrioritiesTexts] {
        get {
            return ArrayConverter.convert(TaskPriorities.texts.entityList(from: self).toArray(), [TaskPrioritiesTexts]())
        }
        set(value) {
            TaskPriorities.texts.setEntityList(in: self, to: EntityValueList.fromArray(ArrayConverter.convert(value, [EntityValue]())))
        }
    }
}
