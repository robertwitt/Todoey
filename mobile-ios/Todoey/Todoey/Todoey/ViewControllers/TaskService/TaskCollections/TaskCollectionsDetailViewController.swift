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

class TaskCollectionsDetailViewController: FUIFormTableViewController, SAPFioriLoadingIndicator {
    var dataService: TaskService<OnlineODataProvider>!
    private var validity = [String: Bool]()
    var allowsEditableCells = false

    private var _entity: TaskServiceFmwk.TaskCollections?
    var entity: TaskServiceFmwk.TaskCollections {
        get {
            if _entity == nil {
                _entity = createEntityWithDefaultValues()
            }
            return _entity!
        }
        set {
            _entity = newValue
        }
    }

    private let logger = Logger.shared(named: "TaskCollectionsMasterViewControllerLogger")
    var loadingIndicator: FUILoadingIndicatorView?
    var entityUpdater: TaskServiceEntityUpdaterDelegate?
    var tableUpdater: TaskServiceEntitySetUpdaterDelegate?
    private let okTitle = NSLocalizedString("keyOkButtonTitle",
                                            value: "OK",
                                            comment: "XBUT: Title of OK button.")
    var preventNavigationLoop = false
    var entitySetName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44

        tableView.register(FUIListPickerFormCell.self, forCellReuseIdentifier: FUIListPickerFormCell.reuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if segue.identifier == "updateEntity" {
            // Show the Detail view with the current entity, where the properties scan be edited and updated
            logger.info("Showing a view to update the selected entity.")
            let dest = segue.destination as! UINavigationController
            let detailViewController = dest.viewControllers[0] as! TaskCollectionsDetailViewController
            detailViewController.title = NSLocalizedString("keyUpdateEntityTitle", value: "Update Entity", comment: "XTIT: Title of update selected entity screen.")
            detailViewController.dataService = dataService
            detailViewController.entity = entity
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: detailViewController, action: #selector(detailViewController.updateEntity))
            detailViewController.navigationItem.rightBarButtonItem = doneButton
            let cancelButton = UIBarButtonItem(title: NSLocalizedString("keyCancelButtonToGoPreviousScreen", value: "Cancel", comment: "XBUT: Title of Cancel button."), style: .plain, target: detailViewController, action: #selector(detailViewController.cancel))
            detailViewController.navigationItem.leftBarButtonItem = cancelButton
            detailViewController.allowsEditableCells = true
            detailViewController.entityUpdater = self
            detailViewController.entitySetName = entitySetName
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return cellForId(tableView: tableView, indexPath: indexPath, currentEntity: entity, property: TaskCollections.id)
        case 1:
            return cellForTitle(tableView: tableView, indexPath: indexPath, currentEntity: entity, property: TaskCollections.title)
        case 2:
            return cellForColor(tableView: tableView, indexPath: indexPath, currentEntity: entity, property: TaskCollections.color)
        case 3:
            return cellForIsDefault_(tableView: tableView, indexPath: indexPath, currentEntity: entity, property: TaskCollections.isDefault_)
        case 4:
            let cell = CellCreationHelper.cellForDefault(tableView: tableView, indexPath: indexPath, editingIsAllowed: false)
            cell.keyName = "Tasks"
            if entity.isNew {
                cell.title.textColor = UIColor.lightGray
            }
            cell.value = " "
            cell.accessoryType = .disclosureIndicator
            return cell

        default:
            return UITableViewCell()
        }
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 5
    }

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        if preventNavigationLoop {
            AlertHelper.displayAlert(with: NSLocalizedString("keyAlertNavigationLoop", value: "No further navigation is possible.", comment: "XTIT: Title of alert message about preventing navigation loop."), error: nil, viewController: self)
            return
        }
        switch indexPath.row {
        case 4:
            if !entity.isNew {
                showFioriLoadingIndicator()
                let destinationStoryBoard = UIStoryboard(name: "Tasks", bundle: nil)
                let masterViewController = destinationStoryBoard.instantiateViewController(withIdentifier: "TasksMaster")
                func loadProperty(_ completionHandler: @escaping ([Tasks]?, Error?) -> Void) {
                    dataService.loadProperty(TaskCollections.tasks, into: entity) { error in
                        self.hideFioriLoadingIndicator()
                        if let error = error {
                            completionHandler(nil, error)
                            return
                        }
                        completionHandler(self.entity.tasks, nil)
                    }
                }
                (masterViewController as! TasksMasterViewController).loadEntitiesBlock = loadProperty
                masterViewController.navigationItem.title = "Tasks"
                (masterViewController as! TasksMasterViewController).preventNavigationLoop = true
                (masterViewController as! TasksMasterViewController).dataService = dataService
                navigationController?.pushViewController(masterViewController, animated: true)
            }
        default:
            return
        }
    }

    // MARK: - OData property specific cell creators

    private func cellForId(tableView: UITableView, indexPath: IndexPath, currentEntity: TaskServiceFmwk.TaskCollections, property: Property) -> UITableViewCell {
        var value = ""
        if let propertyValue = currentEntity.id {
            value = "\(propertyValue)"
        }
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: entity, property: property, value: value, editingIsAllowed: allowsEditableCells, changeHandler:
            { (newValue: String) -> Bool in
                var isNewValueValid = false
                // The property is optional, so nil value can be accepted
                if newValue.isEmpty {
                    currentEntity.id = nil
                    isNewValueValid = true
                } else {
                    if let validValue = GuidValue.parse(newValue) {
                        currentEntity.id = validValue
                        isNewValueValid = true
                    }
                }
                self.validity[property.name] = isNewValueValid
                self.barButtonShouldBeEnabled()
                return isNewValueValid
            })
    }

    private func cellForTitle(tableView: UITableView, indexPath: IndexPath, currentEntity: TaskServiceFmwk.TaskCollections, property: Property) -> UITableViewCell {
        var value = ""
        if let propertyValue = currentEntity.title {
            value = "\(propertyValue)"
        }
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: entity, property: property, value: value, editingIsAllowed: allowsEditableCells, changeHandler:
            { (newValue: String) -> Bool in
                var isNewValueValid = false
                // The property is optional, so nil value can be accepted
                if newValue.isEmpty {
                    currentEntity.title = nil
                    isNewValueValid = true
                } else {
                    if TaskCollections.title.isOptional || newValue != "" {
                        currentEntity.title = newValue
                        isNewValueValid = true
                    }
                }
                self.validity[property.name] = isNewValueValid
                self.barButtonShouldBeEnabled()
                return isNewValueValid
            })
    }

    private func cellForColor(tableView: UITableView, indexPath: IndexPath, currentEntity: TaskServiceFmwk.TaskCollections, property: Property) -> UITableViewCell {
        var value = ""
        if let propertyValue = currentEntity.color {
            value = "\(propertyValue)"
        }
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: entity, property: property, value: value, editingIsAllowed: allowsEditableCells, changeHandler:
            { (newValue: String) -> Bool in
                var isNewValueValid = false
                // The property is optional, so nil value can be accepted
                if newValue.isEmpty {
                    currentEntity.color = nil
                    isNewValueValid = true
                } else {
                    if TaskCollections.color.isOptional || newValue != "" {
                        currentEntity.color = newValue
                        isNewValueValid = true
                    }
                }
                self.validity[property.name] = isNewValueValid
                self.barButtonShouldBeEnabled()
                return isNewValueValid
            })
    }

    private func cellForIsDefault_(tableView: UITableView, indexPath: IndexPath, currentEntity: TaskServiceFmwk.TaskCollections, property: Property) -> UITableViewCell {
        var value = ""
        if let propertyValue = currentEntity.isDefault_ {
            value = "\(propertyValue)"
        }
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: entity, property: property, value: value, editingIsAllowed: allowsEditableCells, changeHandler:
            { (newValue: String) -> Bool in
                var isNewValueValid = false
                // The property is optional, so nil value can be accepted
                if newValue.isEmpty {
                    currentEntity.isDefault_ = nil
                    isNewValueValid = true
                } else {
                    if let validValue = Bool(newValue) {
                        currentEntity.isDefault_ = validValue
                        isNewValueValid = true
                    }
                }
                self.validity[property.name] = isNewValueValid
                self.barButtonShouldBeEnabled()
                return isNewValueValid
            })
    }

    // MARK: - OData functionalities

    @objc func createEntity() {
        showFioriLoadingIndicator()
        view.endEditing(true)
        logger.info("Creating entity in backend.")
        dataService.createEntity(entity) { error in
            self.hideFioriLoadingIndicator()
            if let error = error {
                self.logger.error("Create entry failed. Error: \(error)", error: error)
                AlertHelper.displayAlert(with: NSLocalizedString("keyErrorEntityCreationTitle", value: "Create entry failed", comment: "XTIT: Title of alert message about entity creation error."), error: error, viewController: self)
                return
            }

            self.logger.info("Create entry finished successfully.")
            DispatchQueue.main.async {
                self.dismiss(animated: true) {
                    FUIToastMessage.show(message: NSLocalizedString("keyEntityCreationBody", value: "Created", comment: "XMSG: Title of alert message about successful entity creation."))
                    self.tableUpdater?.entitySetHasChanged()
                }
            }
        }
    }

    func createEntityWithDefaultValues() -> TaskServiceFmwk.TaskCollections {
        let newEntity = TaskServiceFmwk.TaskCollections()

        // Key properties without default value should be invalid by default for Create scenario
        if newEntity.id == nil {
            validity["ID"] = false
        }

        barButtonShouldBeEnabled()
        return newEntity
    }

    @objc func updateEntity(_: AnyObject) {
        showFioriLoadingIndicator()
        view.endEditing(true)
        logger.info("Updating entity in backend.")
        dataService.updateEntity(entity) { error in
            self.hideFioriLoadingIndicator()
            if let error = error {
                self.logger.error("Update entry failed. Error: \(error)", error: error)
                AlertHelper.displayAlert(with: NSLocalizedString("keyErrorEntityUpdateTitle", value: "Update entry failed", comment: "XTIT: Title of alert message about entity update failure."), error: error, viewController: self)
                return
            }

            self.logger.info("Update entry finished successfully.")
            DispatchQueue.main.async {
                self.dismiss(animated: true) {
                    FUIToastMessage.show(message: NSLocalizedString("keyUpdateEntityFinishedTitle", value: "Updated", comment: "XTIT: Title of alert message about successful entity update."))
                    self.entityUpdater?.entityHasChanged(self.entity)
                }
            }
        }
    }

    // MARK: - other logic, helper

    @objc func cancel() {
        showFioriLoadingIndicator()
        view.endEditing(true)
        dataService.loadEntity(entity) { _ in
            self.hideFioriLoadingIndicator()
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
        }
    }

    // Check if all text fields are valid
    private func barButtonShouldBeEnabled() {
        let anyFieldInvalid = validity.values.first { field in
            field == false
        }
        navigationItem.rightBarButtonItem?.isEnabled = anyFieldInvalid == nil
    }
}

extension TaskCollectionsDetailViewController: TaskServiceEntityUpdaterDelegate {
    func entityHasChanged(_ entityValue: EntityValue?) {
        if let entity = entityValue {
            let currentEntity = entity as! TaskServiceFmwk.TaskCollections
            self.entity = currentEntity
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
}
