// # Proxy Compiler 22.9.4

import Foundation
import SAPOData

open class TaskPrioritiesTexts: EntityValue {
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    private static let locale__lock = ObjectBase()

    private static var locale_: Property = TaskServiceMetadata.EntityTypes.taskPrioritiesTexts.property(withName: "locale")

    private static let name__lock = ObjectBase()

    private static var name_: Property = TaskServiceMetadata.EntityTypes.taskPrioritiesTexts.property(withName: "name")

    private static let descr__lock = ObjectBase()

    private static var descr_: Property = TaskServiceMetadata.EntityTypes.taskPrioritiesTexts.property(withName: "descr")

    private static let code__lock = ObjectBase()

    private static var code_: Property = TaskServiceMetadata.EntityTypes.taskPrioritiesTexts.property(withName: "code")

    public init(withDefaults: Bool = true, withIndexMap: SparseIndexMap? = nil) {
        super.init(withDefaults: withDefaults, type: TaskServiceMetadata.EntityTypes.taskPrioritiesTexts, withIndexMap: withIndexMap)
    }

    open class func array(from: EntityValueList) -> [TaskPrioritiesTexts] {
        return ArrayConverter.convert(from.toArray(), [TaskPrioritiesTexts]())
    }

    open class var code: Property {
        get {
            objc_sync_enter(code__lock)
            defer { objc_sync_exit(code__lock) }
            do {
                return TaskPrioritiesTexts.code_
            }
        }
        set(value) {
            objc_sync_enter(code__lock)
            defer { objc_sync_exit(code__lock) }
            do {
                TaskPrioritiesTexts.code_ = value
            }
        }
    }

    open var code: Int? {
        get {
            return UnsignedByte.optional(self.optionalValue(for: TaskPrioritiesTexts.code))
        }
        set(value) {
            self.setOptionalValue(for: TaskPrioritiesTexts.code, to: UnsignedByte.of(optional: value))
        }
    }

    open func copy() -> TaskPrioritiesTexts {
        return CastRequired<TaskPrioritiesTexts>.from(copyEntity())
    }

    open class var descr: Property {
        get {
            objc_sync_enter(descr__lock)
            defer { objc_sync_exit(descr__lock) }
            do {
                return TaskPrioritiesTexts.descr_
            }
        }
        set(value) {
            objc_sync_enter(descr__lock)
            defer { objc_sync_exit(descr__lock) }
            do {
                TaskPrioritiesTexts.descr_ = value
            }
        }
    }

    open var descr: String? {
        get {
            return StringValue.optional(self.optionalValue(for: TaskPrioritiesTexts.descr))
        }
        set(value) {
            self.setOptionalValue(for: TaskPrioritiesTexts.descr, to: StringValue.of(optional: value))
        }
    }

    override open var isProxy: Bool {
        return true
    }

    open class func key(locale: String?, code: Int?) -> EntityKey {
        return EntityKey().with(name: "locale", value: StringValue.of(optional: locale)).with(name: "code", value: UnsignedByte.of(optional: code))
    }

    open class var locale: Property {
        get {
            objc_sync_enter(locale__lock)
            defer { objc_sync_exit(locale__lock) }
            do {
                return TaskPrioritiesTexts.locale_
            }
        }
        set(value) {
            objc_sync_enter(locale__lock)
            defer { objc_sync_exit(locale__lock) }
            do {
                TaskPrioritiesTexts.locale_ = value
            }
        }
    }

    open var locale: String? {
        get {
            return StringValue.optional(self.optionalValue(for: TaskPrioritiesTexts.locale))
        }
        set(value) {
            self.setOptionalValue(for: TaskPrioritiesTexts.locale, to: StringValue.of(optional: value))
        }
    }

    open class var name: Property {
        get {
            objc_sync_enter(name__lock)
            defer { objc_sync_exit(name__lock) }
            do {
                return TaskPrioritiesTexts.name_
            }
        }
        set(value) {
            objc_sync_enter(name__lock)
            defer { objc_sync_exit(name__lock) }
            do {
                TaskPrioritiesTexts.name_ = value
            }
        }
    }

    open var name: String? {
        get {
            return StringValue.optional(self.optionalValue(for: TaskPrioritiesTexts.name))
        }
        set(value) {
            self.setOptionalValue(for: TaskPrioritiesTexts.name, to: StringValue.of(optional: value))
        }
    }

    open var old: TaskPrioritiesTexts {
        return CastRequired<TaskPrioritiesTexts>.from(oldEntity)
    }
}
