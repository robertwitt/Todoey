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

class TasksViewController: FUIFormTableViewController, SAPFioriLoadingIndicator {
    var dataService: TaskService<OnlineODataProvider>!
    public var loadEntitiesBlock: ((_ completionHandler: @escaping ([TaskServiceFmwk.Tasks]?, Error?) -> Void) -> Void)?
    private var entities = [TaskServiceFmwk.Tasks]()

    private let logger = Logger.shared(named: "TasksViewControllerLogger")
    private let okTitle = NSLocalizedString("keyOkButtonTitle",
                                            value: "OK",
                                            comment: "XBUT: Title of OK button.")
    var loadingIndicator: FUILoadingIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Add refreshcontrol UI
        refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl!)
        // Cell height settings
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 98
        updateTable()
    }

    var preventNavigationLoop = false
    var entitySetName: String?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return entities.count
    }

    override func tableView(_: UITableView, canEditRowAt _: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tasks = entities[indexPath.row]

        let cell = CellCreationHelper.objectCellWithNonEditableContent(tableView: tableView, indexPath: indexPath, key: "ID", value: "\(tasks.id!)")
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle != .delete {
            return
        }
        let currentEntity = entities[indexPath.row]
        dataService.deleteEntity(currentEntity) { error in
            if let error = error {
                self.logger.error("Delete entry failed.", error: error)
                AlertHelper.displayAlert(with: NSLocalizedString("keyErrorDeletingEntryTitle", value: "Delete entry failed", comment: "XTIT: Title of deleting entry error pop up."), error: error, viewController: self)
            } else {
                self.entities.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }

    // MARK: - Data accessing

    func requestEntities(completionHandler: @escaping (Error?) -> Void) {
        loadEntitiesBlock! { entities, error in
            if let error = error {
                completionHandler(error)
                return
            }
            self.entities = entities!.sorted(by: { ($0.id!) < ($1.id!) })
            completionHandler(nil)
        }
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if segue.identifier == "showDetail" {
            // Show the selected Entity on the Detail view
            guard let indexPath = tableView.indexPathForSelectedRow else {
                return
            }
            logger.info("Showing details of the chosen element.")
            let selectedEntity = entities[indexPath.row]
            let detailViewController = segue.destination as! TasksDetailViewController
            detailViewController.entity = selectedEntity
            detailViewController.navigationItem.leftItemsSupplementBackButton = true
            detailViewController.navigationItem.title = "\(entities[(tableView.indexPathForSelectedRow?.row)!].id != nil ? "\(entities[(tableView.indexPathForSelectedRow?.row)!].id!)" : "")"
            detailViewController.allowsEditableCells = false
            detailViewController.tableUpdater = self
            detailViewController.preventNavigationLoop = preventNavigationLoop
            detailViewController.dataService = dataService
            detailViewController.entitySetName = entitySetName
        } else if segue.identifier == "addEntity" {
            // Show the Detail view with a new Entity, which can be filled to create on the server
            logger.info("Showing view to add new entity.")
            let dest = segue.destination as! UINavigationController
            let detailViewController = dest.viewControllers[0] as! TasksDetailViewController
            detailViewController.title = NSLocalizedString("keyAddEntityTitle", value: "Add Entity", comment: "XTIT: Title of add new entity screen.")
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: detailViewController, action: #selector(detailViewController.createEntity))
            detailViewController.navigationItem.rightBarButtonItem = doneButton
            let cancelButton = UIBarButtonItem(title: NSLocalizedString("keyCancelButtonToGoPreviousScreen", value: "Cancel", comment: "XBUT: Title of Cancel button."), style: .plain, target: detailViewController, action: #selector(detailViewController.cancel))
            detailViewController.navigationItem.leftBarButtonItem = cancelButton
            detailViewController.allowsEditableCells = true
            detailViewController.tableUpdater = self
            detailViewController.dataService = dataService
            detailViewController.entitySetName = entitySetName
        }
    }

    // MARK: - Table update

    func updateTable() {
        showFioriLoadingIndicator()
        DispatchQueue.global().async {
            self.loadData {
                self.hideFioriLoadingIndicator()
            }
        }
    }

    private func loadData(completionHandler: @escaping () -> Void) {
        requestEntities { error in
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

    @objc func refresh() {
        DispatchQueue.global().async {
            self.loadData {
                DispatchQueue.main.async {
                    self.refreshControl?.endRefreshing()
                }
            }
        }
    }
}

extension TasksViewController: TaskServiceEntitySetUpdaterDelegate {
    func entitySetHasChanged() {
        updateTable()
    }
}
