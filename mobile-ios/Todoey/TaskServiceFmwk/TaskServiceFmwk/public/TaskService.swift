// # Proxy Compiler 22.9.4

import Foundation
import SAPOData

open class TaskService<Provider: DataServiceProvider>: LegacyDataService<Provider> {
    override public init(provider: Provider) {
        super.init(provider: provider)
        self.provider.metadata = TaskServiceMetadata.document
        ProxyInternal.setCsdlFetcher(provider: self.provider, fetcher: nil)
        ProxyInternal.setCsdlOptions(provider: self.provider, options: TaskServiceMetadataParser.options)
    }

    open func defaultTaskCollection(query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> TaskCollections? {
        let var_query = DataQuery.newIfNull(query: query)
        return try CastOptional<TaskCollections>.from(executeQuery(var_query.invoke(TaskServiceMetadata.FunctionImports.getDefaultTaskCollection, ParameterList.empty), headers: headers, options: options).checkedResult())
    }

    open func defaultTaskCollection(query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil, completionHandler: @escaping (TaskCollections?, Error?) -> Void) {
        asyncFunction {
            do {
                try self.checkIfCancelled(options?.cancelToken)
                let result = try self.defaultTaskCollection(query: query, headers: headers, options: options)
                self.completionQueue.addOperation { completionHandler(result, nil) }
            } catch {
                self.completionQueue.addOperation { completionHandler(nil, error) }
            }
        }
    }

    open func fetchTaskCollections(matching query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> [TaskCollections] {
        let var_query = DataQuery.newIfNull(query: query)
        return try TaskCollections.array(from: executeQuery(var_query.fromDefault(TaskServiceMetadata.EntitySets.taskCollections), headers: headers, options: options).entityList())
    }

    open func fetchTaskCollections(matching query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil, completionHandler: @escaping ([TaskCollections]?, Error?) -> Void) {
        asyncFunction {
            do {
                try self.checkIfCancelled(options?.cancelToken)
                let result = try self.fetchTaskCollections(matching: query, headers: headers, options: options)
                self.completionQueue.addOperation { completionHandler(result, nil) }
            } catch {
                self.completionQueue.addOperation { completionHandler(nil, error) }
            }
        }
    }

    open func fetchTaskCollections1(matching query: DataQuery, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> TaskCollections {
        return try CastRequired<TaskCollections>.from(executeQuery(query.fromDefault(TaskServiceMetadata.EntitySets.taskCollections), headers: headers, options: options).requiredEntity())
    }

    open func fetchTaskCollections1(matching query: DataQuery, headers: HTTPHeaders? = nil, options: RequestOptions? = nil, completionHandler: @escaping (TaskCollections?, Error?) -> Void) {
        asyncFunction {
            do {
                try self.checkIfCancelled(options?.cancelToken)
                let result = try self.fetchTaskCollections1(matching: query, headers: headers, options: options)
                self.completionQueue.addOperation { completionHandler(result, nil) }
            } catch {
                self.completionQueue.addOperation { completionHandler(nil, error) }
            }
        }
    }

    open func fetchTaskCollections1WithKey(id: GuidValue?, query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> TaskCollections {
        let var_query = DataQuery.newIfNull(query: query)
        return try fetchTaskCollections1(matching: var_query.withKey(TaskCollections.key(id: id)), headers: headers, options: options)
    }

    open func fetchTaskCollections1WithKey(id: GuidValue?, query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil, completionHandler: @escaping (TaskCollections?, Error?) -> Void) {
        asyncFunction {
            do {
                try self.checkIfCancelled(options?.cancelToken)
                let result = try self.fetchTaskCollections1WithKey(id: id, query: query, headers: headers, options: options)
                self.completionQueue.addOperation { completionHandler(result, nil) }
            } catch {
                self.completionQueue.addOperation { completionHandler(nil, error) }
            }
        }
    }

    open func fetchTaskPriorities(matching query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> [TaskPriorities] {
        let var_query = DataQuery.newIfNull(query: query)
        return try TaskPriorities.array(from: executeQuery(var_query.fromDefault(TaskServiceMetadata.EntitySets.taskPriorities), headers: headers, options: options).entityList())
    }

    open func fetchTaskPriorities(matching query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil, completionHandler: @escaping ([TaskPriorities]?, Error?) -> Void) {
        asyncFunction {
            do {
                try self.checkIfCancelled(options?.cancelToken)
                let result = try self.fetchTaskPriorities(matching: query, headers: headers, options: options)
                self.completionQueue.addOperation { completionHandler(result, nil) }
            } catch {
                self.completionQueue.addOperation { completionHandler(nil, error) }
            }
        }
    }

    open func fetchTaskPriorities1(matching query: DataQuery, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> TaskPriorities {
        return try CastRequired<TaskPriorities>.from(executeQuery(query.fromDefault(TaskServiceMetadata.EntitySets.taskPriorities), headers: headers, options: options).requiredEntity())
    }

    open func fetchTaskPriorities1(matching query: DataQuery, headers: HTTPHeaders? = nil, options: RequestOptions? = nil, completionHandler: @escaping (TaskPriorities?, Error?) -> Void) {
        asyncFunction {
            do {
                try self.checkIfCancelled(options?.cancelToken)
                let result = try self.fetchTaskPriorities1(matching: query, headers: headers, options: options)
                self.completionQueue.addOperation { completionHandler(result, nil) }
            } catch {
                self.completionQueue.addOperation { completionHandler(nil, error) }
            }
        }
    }

    open func fetchTaskPriorities1WithKey(code: Int?, query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> TaskPriorities {
        let var_query = DataQuery.newIfNull(query: query)
        return try fetchTaskPriorities1(matching: var_query.withKey(TaskPriorities.key(code: code)), headers: headers, options: options)
    }

    open func fetchTaskPriorities1WithKey(code: Int?, query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil, completionHandler: @escaping (TaskPriorities?, Error?) -> Void) {
        asyncFunction {
            do {
                try self.checkIfCancelled(options?.cancelToken)
                let result = try self.fetchTaskPriorities1WithKey(code: code, query: query, headers: headers, options: options)
                self.completionQueue.addOperation { completionHandler(result, nil) }
            } catch {
                self.completionQueue.addOperation { completionHandler(nil, error) }
            }
        }
    }

    open func fetchTaskPrioritiesTexts(matching query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> [TaskPrioritiesTexts] {
        let var_query = DataQuery.newIfNull(query: query)
        return try TaskPrioritiesTexts.array(from: executeQuery(var_query.fromDefault(TaskServiceMetadata.EntitySets.taskPrioritiesTexts), headers: headers, options: options).entityList())
    }

    open func fetchTaskPrioritiesTexts(matching query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil, completionHandler: @escaping ([TaskPrioritiesTexts]?, Error?) -> Void) {
        asyncFunction {
            do {
                try self.checkIfCancelled(options?.cancelToken)
                let result = try self.fetchTaskPrioritiesTexts(matching: query, headers: headers, options: options)
                self.completionQueue.addOperation { completionHandler(result, nil) }
            } catch {
                self.completionQueue.addOperation { completionHandler(nil, error) }
            }
        }
    }

    open func fetchTaskPrioritiesTexts1(matching query: DataQuery, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> TaskPrioritiesTexts {
        return try CastRequired<TaskPrioritiesTexts>.from(executeQuery(query.fromDefault(TaskServiceMetadata.EntitySets.taskPrioritiesTexts), headers: headers, options: options).requiredEntity())
    }

    open func fetchTaskPrioritiesTexts1(matching query: DataQuery, headers: HTTPHeaders? = nil, options: RequestOptions? = nil, completionHandler: @escaping (TaskPrioritiesTexts?, Error?) -> Void) {
        asyncFunction {
            do {
                try self.checkIfCancelled(options?.cancelToken)
                let result = try self.fetchTaskPrioritiesTexts1(matching: query, headers: headers, options: options)
                self.completionQueue.addOperation { completionHandler(result, nil) }
            } catch {
                self.completionQueue.addOperation { completionHandler(nil, error) }
            }
        }
    }

    open func fetchTaskPrioritiesTexts1WithKey(locale: String?, code: Int?, query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> TaskPrioritiesTexts {
        let var_query = DataQuery.newIfNull(query: query)
        return try fetchTaskPrioritiesTexts1(matching: var_query.withKey(TaskPrioritiesTexts.key(locale: locale, code: code)), headers: headers, options: options)
    }

    open func fetchTaskPrioritiesTexts1WithKey(locale: String?, code: Int?, query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil, completionHandler: @escaping (TaskPrioritiesTexts?, Error?) -> Void) {
        asyncFunction {
            do {
                try self.checkIfCancelled(options?.cancelToken)
                let result = try self.fetchTaskPrioritiesTexts1WithKey(locale: locale, code: code, query: query, headers: headers, options: options)
                self.completionQueue.addOperation { completionHandler(result, nil) }
            } catch {
                self.completionQueue.addOperation { completionHandler(nil, error) }
            }
        }
    }

    open func fetchTasks(matching query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> [Tasks] {
        let var_query = DataQuery.newIfNull(query: query)
        return try Tasks.array(from: executeQuery(var_query.fromDefault(TaskServiceMetadata.EntitySets.tasks), headers: headers, options: options).entityList())
    }

    open func fetchTasks(matching query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil, completionHandler: @escaping ([Tasks]?, Error?) -> Void) {
        asyncFunction {
            do {
                try self.checkIfCancelled(options?.cancelToken)
                let result = try self.fetchTasks(matching: query, headers: headers, options: options)
                self.completionQueue.addOperation { completionHandler(result, nil) }
            } catch {
                self.completionQueue.addOperation { completionHandler(nil, error) }
            }
        }
    }

    open func fetchTasks1(matching query: DataQuery, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> Tasks {
        return try CastRequired<Tasks>.from(executeQuery(query.fromDefault(TaskServiceMetadata.EntitySets.tasks), headers: headers, options: options).requiredEntity())
    }

    open func fetchTasks1(matching query: DataQuery, headers: HTTPHeaders? = nil, options: RequestOptions? = nil, completionHandler: @escaping (Tasks?, Error?) -> Void) {
        asyncFunction {
            do {
                try self.checkIfCancelled(options?.cancelToken)
                let result = try self.fetchTasks1(matching: query, headers: headers, options: options)
                self.completionQueue.addOperation { completionHandler(result, nil) }
            } catch {
                self.completionQueue.addOperation { completionHandler(nil, error) }
            }
        }
    }

    open func fetchTasks1WithKey(id: GuidValue?, query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> Tasks {
        let var_query = DataQuery.newIfNull(query: query)
        return try fetchTasks1(matching: var_query.withKey(Tasks.key(id: id)), headers: headers, options: options)
    }

    open func fetchTasks1WithKey(id: GuidValue?, query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil, completionHandler: @escaping (Tasks?, Error?) -> Void) {
        asyncFunction {
            do {
                try self.checkIfCancelled(options?.cancelToken)
                let result = try self.fetchTasks1WithKey(id: id, query: query, headers: headers, options: options)
                self.completionQueue.addOperation { completionHandler(result, nil) }
            } catch {
                self.completionQueue.addOperation { completionHandler(nil, error) }
            }
        }
    }

    override open var metadataLock: MetadataLock {
        return TaskServiceMetadata.lock
    }

    override open func refreshMetadata() throws {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        do {
            try ProxyInternal.refreshMetadata(generic: self, fetcher: nil, options: TaskServiceMetadataParser.options, mergeAction: { TaskServiceMetadataChanges.merge(metadata: self.metadata) })
        }
    }

    override open func refreshMetadata(completionHandler: @escaping (Error?) -> Void) {
        asyncFunction {
            do {
                try self.refreshMetadata()
                self.completionQueue.addOperation { completionHandler(nil) }
            } catch {
                self.completionQueue.addOperation { completionHandler(error) }
            }
        }
    }

    open func setDefaultTaskCollection(collectionID: GuidValue?, query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws {
        let var_query = DataQuery.newIfNull(query: query)
        _ = try executeQuery(var_query.invoke(TaskServiceMetadata.ActionImports.setDefaultTaskCollection, ParameterList(capacity: 1 as Int).with(name: "collectionID", value: collectionID)), headers: headers, options: options)
    }

    open func setDefaultTaskCollection(collectionID: GuidValue?, query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil, completionHandler: @escaping (Error?) -> Void) {
        asyncAction {
            do {
                try self.checkIfCancelled(options?.cancelToken)
                try self.setDefaultTaskCollection(collectionID: collectionID, query: query, headers: headers, options: options)
                self.completionQueue.addOperation { completionHandler(nil) }
            } catch {
                self.completionQueue.addOperation { completionHandler(error) }
            }
        }
    }

    open func setToDone(in: BindingPath, query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws {
        let var_query = DataQuery.newIfNull(query: query)
        _ = try executeQuery(var_query.bind(`in`).invoke(TaskServiceMetadata.BoundActions.setToDone, ParameterList.empty), headers: headers, options: options)
    }

    open func setToDone(in: BindingPath, query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil, completionHandler: @escaping (Error?) -> Void) {
        asyncAction {
            do {
                try self.checkIfCancelled(options?.cancelToken)
                try self.setToDone(in: `in`, query: query, headers: headers, options: options)
                self.completionQueue.addOperation { completionHandler(nil) }
            } catch {
                self.completionQueue.addOperation { completionHandler(error) }
            }
        }
    }
}
