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

class TaskPrioritiesTextsDetailViewController: FUIFormTableViewController, SAPFioriLoadingIndicator {
    var dataService: TaskService<OnlineODataProvider>!
    private var validity = [String: Bool]()
    var allowsEditableCells = false

    private var _entity: TaskServiceFmwk.TaskPrioritiesTexts?
    var entity: TaskServiceFmwk.TaskPrioritiesTexts {
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

    private let logger = Logger.shared(named: "TaskPrioritiesTextsMasterViewControllerLogger")
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
            let detailViewController = dest.viewControllers[0] as! TaskPrioritiesTextsDetailViewController
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
            return cellForLocale(tableView: tableView, indexPath: indexPath, currentEntity: entity, property: TaskPrioritiesTexts.locale)
        case 1:
            return cellForName(tableView: tableView, indexPath: indexPath, currentEntity: entity, property: TaskPrioritiesTexts.name)
        case 2:
            return cellForDescr(tableView: tableView, indexPath: indexPath, currentEntity: entity, property: TaskPrioritiesTexts.descr)
        case 3:
            return cellForCode(tableView: tableView, indexPath: indexPath, currentEntity: entity, property: TaskPrioritiesTexts.code)
        default:
            return UITableViewCell()
        }
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 4
    }

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        if preventNavigationLoop {
            AlertHelper.displayAlert(with: NSLocalizedString("keyAlertNavigationLoop", value: "No further navigation is possible.", comment: "XTIT: Title of alert message about preventing navigation loop."), error: nil, viewController: self)
            return
        }
        switch indexPath.row {
        default:
            return
        }
    }

    // MARK: - OData property specific cell creators

    private func cellForLocale(tableView: UITableView, indexPath: IndexPath, currentEntity: TaskServiceFmwk.TaskPrioritiesTexts, property: Property) -> UITableViewCell {
        var value = ""
        if let propertyValue = currentEntity.locale {
            value = "\(propertyValue)"
        }
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: entity, property: property, value: value, editingIsAllowed: allowsEditableCells, changeHandler:
            { (newValue: String) -> Bool in
                var isNewValueValid = false
                // The property is optional, so nil value can be accepted
                if newValue.isEmpty {
                    currentEntity.locale = nil
                    isNewValueValid = true
                } else {
                    if TaskPrioritiesTexts.locale.isOptional || newValue != "" {
                        currentEntity.locale = newValue
                        isNewValueValid = true
                    }
                }
                self.validity[property.name] = isNewValueValid
                self.barButtonShouldBeEnabled()
                return isNewValueValid
            })
    }

    private func cellForName(tableView: UITableView, indexPath: IndexPath, currentEntity: TaskServiceFmwk.TaskPrioritiesTexts, property: Property) -> UITableViewCell {
        var value = ""
        if let propertyValue = currentEntity.name {
            value = "\(propertyValue)"
        }
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: entity, property: property, value: value, editingIsAllowed: allowsEditableCells, changeHandler:
            { (newValue: String) -> Bool in
                var isNewValueValid = false
                // The property is optional, so nil value can be accepted
                if newValue.isEmpty {
                    currentEntity.name = nil
                    isNewValueValid = true
                } else {
                    if TaskPrioritiesTexts.name.isOptional || newValue != "" {
                        currentEntity.name = newValue
                        isNewValueValid = true
                    }
                }
                self.validity[property.name] = isNewValueValid
                self.barButtonShouldBeEnabled()
                return isNewValueValid
            })
    }

    private func cellForDescr(tableView: UITableView, indexPath: IndexPath, currentEntity: TaskServiceFmwk.TaskPrioritiesTexts, property: Property) -> UITableViewCell {
        var value = ""
        if let propertyValue = currentEntity.descr {
            value = "\(propertyValue)"
        }
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: entity, property: property, value: value, editingIsAllowed: allowsEditableCells, changeHandler:
            { (newValue: String) -> Bool in
                var isNewValueValid = false
                // The property is optional, so nil value can be accepted
                if newValue.isEmpty {
                    currentEntity.descr = nil
                    isNewValueValid = true
                } else {
                    if TaskPrioritiesTexts.descr.isOptional || newValue != "" {
                        currentEntity.descr = newValue
                        isNewValueValid = true
                    }
                }
                self.validity[property.name] = isNewValueValid
                self.barButtonShouldBeEnabled()
                return isNewValueValid
            })
    }

    private func cellForCode(tableView: UITableView, indexPath: IndexPath, currentEntity: TaskServiceFmwk.TaskPrioritiesTexts, property: Property) -> UITableViewCell {
        var value = ""
        if let propertyValue = currentEntity.code {
            value = "\(propertyValue)"
        }
        return CellCreationHelper.cellForProperty(tableView: tableView, indexPath: indexPath, entity: entity, property: property, value: value, editingIsAllowed: allowsEditableCells, changeHandler:
            { (newValue: String) -> Bool in
                var isNewValueValid = false
                // The property is optional, so nil value can be accepted
                if newValue.isEmpty {
                    currentEntity.code = nil
                    isNewValueValid = true
                } else {
                    if let validValue = Int(newValue) {
                        currentEntity.code = validValue
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

    func createEntityWithDefaultValues() -> TaskServiceFmwk.TaskPrioritiesTexts {
        let newEntity = TaskServiceFmwk.TaskPrioritiesTexts()

        // Key properties without default value should be invalid by default for Create scenario
        if newEntity.locale == nil || newEntity.locale!.isEmpty {
            validity["locale"] = false
        }
        if newEntity.code == nil {
            validity["code"] = false
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

extension TaskPrioritiesTextsDetailViewController: TaskServiceEntityUpdaterDelegate {
    func entityHasChanged(_ entityValue: EntityValue?) {
        if let entity = entityValue {
            let currentEntity = entity as! TaskServiceFmwk.TaskPrioritiesTexts
            self.entity = currentEntity
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
}
