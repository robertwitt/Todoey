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
    }
    
    private func setupNavigationBar() {
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.title = task == nil ? LocalizedStrings.TaskView.createTaskTitle : LocalizedStrings.TaskView.editTaskTitle
    }
    
    private func setupTableView() {
        tableView.register(FUITextFieldFormCell.self, forCellReuseIdentifier: FUITextFieldFormCell.reuseIdentifier)
                
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
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
            cell.isStacked = false
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
