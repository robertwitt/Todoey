//
// Todoey
//
// Created by SAP BTP SDK Assistant for iOS v9.0.4 application on 14/02/23
//

import Foundation
import SAPCommon
import SAPFiori
import SAPFoundation
import SAPOData
import TaskServiceFmwk

class TaskViewController: FUIFormTableViewController, SAPFioriLoadingIndicator {
    
    var dataService: TaskService<OnlineODataProvider>!
    var task: Tasks!
    var loadingIndicator: FUILoadingIndicatorView?
    
    private var taskCollections = [TaskCollections]()
    private var taskPriorities = [TaskPriorities]()
    private let logger = Logger.shared(named: "TaskViewControllerLogger")
    
//    private var validity = [String: Bool]()
//    var allowsEditableCells = false
//
//    private var _entity: TaskServiceFmwk.Tasks?
//    var entity: TaskServiceFmwk.Tasks {
//        get {
//            if _entity == nil {
//                _entity = createEntityWithDefaultValues()
//            }
//            return _entity!
//        }
//        set {
//            _entity = newValue
//        }
//    }
//
//    var entityUpdater: TaskServiceEntityUpdaterDelegate?
//    var tableUpdater: TaskServiceEntitySetUpdaterDelegate?
//
//    var preventNavigationLoop = false
//    var entitySetName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        updateValueHelps()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.title = task == nil ? LocalizedStrings.TaskView.createTaskTitle : LocalizedStrings.TaskView.editTaskTitle
    }
    
    private func setupTableView() {
        tableView.register(FUITextFieldFormCell.self, forCellReuseIdentifier: FUITextFieldFormCell.reuseIdentifier)
        tableView.register(FUIListPickerFormCell.self, forCellReuseIdentifier: FUIListPickerFormCell.reuseIdentifier)
                
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
    }
    
    // MARK: Load data
    
    private func updateValueHelps() {
        showFioriLoadingIndicator()
        DispatchQueue.global().async {
            self.loadValueHelps {
                self.hideFioriLoadingIndicator()
            }
        }
    }

    private func loadValueHelps(completionHandler: @escaping () -> Void) {
        requestValueHelps { error in
            defer {
                completionHandler()
            }
            if let error = error {
                AlertHelper.displayAlert(with: NSLocalizedString("keyErrorLoadingData", value: "Loading data failed!", comment: "XTIT: Title of loading data error pop up."), error: error, viewController: self)
                self.logger.error("Could not update table. Error: \(error)", error: error)
                return
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.logger.info("Table updated successfully!")
            }
        }
    }
    
    private func requestValueHelps(completionHandler: @escaping (Error?) -> Void) {
        taskCollections = []
        taskPriorities = []
        
        let batch = RequestBatch()
        let queryCollections = DataQuery()
            .from(dataService.entitySet(withName: "TaskCollections"))
            .select(TaskCollections.id, TaskCollections.title)
            .orderBy(TaskCollections.title)
        batch.addQuery(queryCollections)
        let queryPriorities = DataQuery()
            .from(dataService.entitySet(withName: "TaskPriorities"))
            .select(TaskPriorities.code, TaskPriorities.name)
            .orderBy(TaskPriorities.code)
        batch.addQuery(queryPriorities)
        
        dataService.processBatch(batch) { error in
            if let error = error {
                completionHandler(error)
            }
            do {
                self.taskCollections = try batch.queryResult(for: queryCollections).entityList().toArray() as! [TaskCollections]
                self.taskPriorities = try batch.queryResult(for: queryPriorities).entityList().toArray() as! [TaskPriorities]
                completionHandler(nil)
            } catch {
                completionHandler(error)
            }
            
        }
        
//        let query = DataQuery().select(TaskCollections.id, TaskCollections.title).orderBy(TaskCollections.title)
//        dataService.fetchTaskCollections(matching: query) { taskCollections, error in
//            if let error = error {
//                completionHandler(error)
//                return
//            }
//            self.taskCollections = taskCollections
//
//            dataService.ba
//        }
//
//        loadEntitiesBlock! { entities, error in
//            if let error = error {
//                completionHandler(error)
//                return
//            }
//            self.entities = entities!.sorted(by: { ($0.id!) < ($1.id!) })
//            completionHandler(nil)
//        }
    }

    // MARK: Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Row.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Row(rawValue: indexPath.row) {
        case .title:
            let cell = tableView.dequeueReusableCell(withIdentifier: FUITextFieldFormCell.reuseIdentifier, for: indexPath) as! FUITextFieldFormCell
            cell.keyName = LocalizedStrings.Model.taskTitle
            cell.value = task.title ?? ""
            cell.isEditable = true
            cell.isStacked = false
            cell.onChangeHandler = { newValue in
                // TODO
            }
            return cell
        case .collection:
            let cell = tableView.dequeueReusableCell(withIdentifier: FUIListPickerFormCell.reuseIdentifier, for: indexPath) as! FUIListPickerFormCell
            cell.keyName = "Work Group"
            cell.value = taskCollections.count == 0 ? [] : [taskCollections.firstIndex { $0.id == task.collectionID }!]
            cell.isEditable = true
            cell.allowsMultipleSelection = false
            cell.allowsEmptySelection = false
            cell.valueLabel.text = task.collection?.title
            cell.valueOptions = taskCollections.map { $0.title! }
            cell.onChangeHandler = { [weak self] newValues in
                // TODO newValues is array of index of selected item in valueOptions
            }
            return cell
        default:
            return UITableViewCell()
        }
    }

    // MARK: Segues

//    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
//        if segue.identifier == "updateEntity" {
//            // Show the Detail view with the current entity, where the properties scan be edited and updated
//            logger.info("Showing a view to update the selected entity.")
//            let dest = segue.destination as! UINavigationController
//            let detailViewController = dest.viewControllers[0] as! TaskViewController
//            detailViewController.title = NSLocalizedString("keyUpdateEntityTitle", value: "Update Entity", comment: "XTIT: Title of update selected entity screen.")
//            detailViewController.dataService = dataService
//            detailViewController.entity = entity
//            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: detailViewController, action: #selector(detailViewController.updateEntity))
//            detailViewController.navigationItem.rightBarButtonItem = doneButton
//            let cancelButton = UIBarButtonItem(title: NSLocalizedString("keyCancelButtonToGoPreviousScreen", value: "Cancel", comment: "XBUT: Title of Cancel button."), style: .plain, target: detailViewController, action: #selector(detailViewController.cancel))
//            detailViewController.navigationItem.leftBarButtonItem = cancelButton
//            detailViewController.allowsEditableCells = true
//            detailViewController.entityUpdater = self
//            detailViewController.entitySetName = entitySetName
//        }
//    }
    

    // MARK: - OData functionalities

//    @objc func createEntity() {
//        showFioriLoadingIndicator()
//        view.endEditing(true)
//        logger.info("Creating entity in backend.")
//        dataService.createEntity(entity) { error in
//            self.hideFioriLoadingIndicator()
//            if let error = error {
//                self.logger.error("Create entry failed. Error: \(error)", error: error)
//                AlertHelper.displayAlert(with: NSLocalizedString("keyErrorEntityCreationTitle", value: "Create entry failed", comment: "XTIT: Title of alert message about entity creation error."), error: error, viewController: self)
//                return
//            }
//
//            self.logger.info("Create entry finished successfully.")
//            DispatchQueue.main.async {
//                self.dismiss(animated: true) {
//                    FUIToastMessage.show(message: NSLocalizedString("keyEntityCreationBody", value: "Created", comment: "XMSG: Title of alert message about successful entity creation."))
//                    self.tableUpdater?.entitySetHasChanged()
//                }
//            }
//        }
//    }
//
//    func createEntityWithDefaultValues() -> TaskServiceFmwk.Tasks {
//        let newEntity = TaskServiceFmwk.Tasks()
//
//        // Key properties without default value should be invalid by default for Create scenario
//        if newEntity.id == nil {
//            validity["ID"] = false
//        }
//
//        barButtonShouldBeEnabled()
//        return newEntity
//    }
//
//    @objc func updateEntity(_: AnyObject) {
//        showFioriLoadingIndicator()
//        view.endEditing(true)
//        logger.info("Updating entity in backend.")
//        dataService.updateEntity(entity) { error in
//            self.hideFioriLoadingIndicator()
//            if let error = error {
//                self.logger.error("Update entry failed. Error: \(error)", error: error)
//                AlertHelper.displayAlert(with: NSLocalizedString("keyErrorEntityUpdateTitle", value: "Update entry failed", comment: "XTIT: Title of alert message about entity update failure."), error: error, viewController: self)
//                return
//            }
//
//            self.logger.info("Update entry finished successfully.")
//            DispatchQueue.main.async {
//                self.dismiss(animated: true) {
//                    FUIToastMessage.show(message: NSLocalizedString("keyUpdateEntityFinishedTitle", value: "Updated", comment: "XTIT: Title of alert message about successful entity update."))
//                    self.entityUpdater?.entityHasChanged(self.entity)
//                }
//            }
//        }
//    }
//
//    // MARK: - other logic, helper
//
//    @objc func cancel() {
//        showFioriLoadingIndicator()
//        view.endEditing(true)
//        dataService.loadEntity(entity) { _ in
//            self.hideFioriLoadingIndicator()
//            DispatchQueue.main.async {
//                self.dismiss(animated: true)
//            }
//        }
//    }
//
//    // Check if all text fields are valid
//    private func barButtonShouldBeEnabled() {
//        let anyFieldInvalid = validity.values.first { field in
//            field == false
//        }
//        navigationItem.rightBarButtonItem?.isEnabled = anyFieldInvalid == nil
//    }
    
}

//extension TaskViewController: TaskServiceEntityUpdaterDelegate {
//    func entityHasChanged(_ entityValue: EntityValue?) {
//        if let entity = entityValue {
//            let currentEntity = entity as! TaskServiceFmwk.Tasks
//            self.entity = currentEntity
//            DispatchQueue.main.async { [weak self] in
//                self?.tableView.reloadData()
//            }
//        }
//    }
//}

fileprivate enum Row: Int {
    case title = 0
    case collection = 1
    case priority = 2
    case dueDate = 3
    case dueTime = 4
    case isPlannedForMyDay = 5
    static let count = 6
}
