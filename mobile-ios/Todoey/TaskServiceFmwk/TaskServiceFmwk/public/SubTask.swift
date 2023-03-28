// # Proxy Compiler 22.9.4

import Foundation
import SAPOData

open class SubTask: ComplexValue {
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    private static let title__lock = ObjectBase()

    private static var title_: Property = TaskServiceMetadata.ComplexTypes.subTask.property(withName: "title")

    private static let isDone__lock = ObjectBase()

    private static var isDone_: Property = TaskServiceMetadata.ComplexTypes.subTask.property(withName: "isDone")

    public init(withDefaults: Bool = true, withIndexMap: SparseIndexMap? = nil) {
        super.init(withDefaults: withDefaults, type: TaskServiceMetadata.ComplexTypes.subTask, withIndexMap: withIndexMap)
    }

    open func copy() -> SubTask {
        return CastRequired<SubTask>.from(copyComplex())
    }

    open class var isDone: Property {
        get {
            objc_sync_enter(isDone__lock)
            defer { objc_sync_exit(isDone__lock) }
            do {
                return SubTask.isDone_
            }
        }
        set(value) {
            objc_sync_enter(isDone__lock)
            defer { objc_sync_exit(isDone__lock) }
            do {
                SubTask.isDone_ = value
            }
        }
    }

    open var isDone: Bool? {
        get {
            return BooleanValue.optional(self.optionalValue(for: SubTask.isDone))
        }
        set(value) {
            self.setOptionalValue(for: SubTask.isDone, to: BooleanValue.of(optional: value))
        }
    }

    override open var isProxy: Bool {
        return true
    }

    open var old: SubTask {
        return CastRequired<SubTask>.from(self.oldComplex)
    }

    open class var title: Property {
        get {
            objc_sync_enter(title__lock)
            defer { objc_sync_exit(title__lock) }
            do {
                return SubTask.title_
            }
        }
        set(value) {
            objc_sync_enter(title__lock)
            defer { objc_sync_exit(title__lock) }
            do {
                SubTask.title_ = value
            }
        }
    }

    open var title: String? {
        get {
            return StringValue.optional(optionalValue(for: SubTask.title))
        }
        set(value) {
            setOptionalValue(for: SubTask.title, to: StringValue.of(optional: value))
        }
    }
}
