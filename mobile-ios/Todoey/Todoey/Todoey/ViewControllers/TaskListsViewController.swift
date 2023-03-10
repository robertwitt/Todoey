//
// Todoey
//
// Created by SAP BTP SDK Assistant for iOS v9.0.4 application on 14/02/23
//

import UIKit
import SAPCommon
import SAPFiori
import SAPFioriFlows
import SAPOData
import SharedFmwk
import TaskServiceFmwk

class TaskListsViewController: FUIFormTableViewController, SAPFioriLoadingIndicator {
    
    var loadingIndicator: FUILoadingIndicatorView?
    
    private let cellIdentifier = "TaskListCell"
    private var selectedIndex: IndexPath?
    
    private var isPresentedInSplitView: Bool {
        return !(self.splitViewController?.isCollapsed ?? true)
    }
    
    private var dataService: TaskService<OnlineODataProvider>!
    private var model: TaskListsViewModel!
    private let logger = Logger.shared(named: "TaskListsViewControllerLogger")

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupDataService()
        updateTable()
    }
    
    private func setupTableView() {
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(FUIObjectTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        self.refreshControl = refreshControl
        tableView.addSubview(refreshControl)
    }
    
    private func setupDataService() {
        guard let odataController = OnboardingSessionManager.shared.onboardingSession?.odataControllers[ODataContainerType.taskService.description] as? TaskServiceOnlineODataController, let dataService = odataController.dataService else {
            AlertHelper.displayAlert(with: LocalizedStrings.OnlineOData.oDataServiceFailedMessage, error: nil, viewController: self)
            return
        }
        self.dataService = dataService
        model = TaskListsViewModel(taskService: dataService)
    }

    override func viewWillTransition(to _: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: nil, completion: { _ in
            let isNotInSplitView = !self.isPresentedInSplitView
            self.tableView.visibleCells.forEach { cell in
                // To refresh the disclosure indicator of each cell
                cell.accessoryType = isNotInSplitView ? .disclosureIndicator : .none
            }
            self.makeSelection()
        })
    }
    
    // MARK: Update table
    
    private func updateTable() {
        showFioriLoadingIndicator()
        DispatchQueue.global().async {
            self.loadData {
                self.hideFioriLoadingIndicator()
            }
        }
    }

    private func loadData(completionHandler: @escaping () -> Void) {
        model.reloadData { error in
            defer {
                completionHandler()
            }
            if let error = error {
                AlertHelper.displayAlert(with: LocalizedStrings.OnlineOData.errorLoadingData, error: error, viewController: self)
                self.logger.error("Could not update table. Error: \(error)", error: error)
                return
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.makeSelection()
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

    // MARK: Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return model.numberOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.numberOfObjects(inSection: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let taskList = model.object(at: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! FUIObjectTableViewCell
        cell.iconImages = [taskList.icon.withRenderingMode(.alwaysTemplate)]
        cell.headlineText = taskList.title
        
        if let color = taskList.displayColor {
            cell.headlineLabel.textColor = color
        }
        
        cell.statusText = "\(taskList.tasks.count)"
        cell.accessoryType = !isPresentedInSplitView ? .disclosureIndicator : .none
        cell.splitPercent = CGFloat(0.3)
        cell.isMomentarySelection = false
        
        return cell
    }
    
    // MARK: Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectTaskList(at: indexPath)
    }
    
    private func selectTaskList(at indexPath: IndexPath) {
        selectedIndex = indexPath

        let storyboard = UIStoryboard(name: "Tasks", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "TasksMaster") as! TasksViewController
        viewController.dataService = dataService
        viewController.taskList = model.object(at: indexPath)
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let rightNavigationController = mainStoryBoard.instantiateViewController(withIdentifier: "RightNavigationController") as! UINavigationController
        rightNavigationController.viewControllers = [viewController]
        splitViewController?.showDetailViewController(rightNavigationController, sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let taskList = model.object(at: indexPath)
        guard taskList.isEditable else {
            return nil
        }
        
        let setDefaultAction = UIContextualAction(style: .normal, title: LocalizedStrings.TaskListView.setDefaultActionTitle) { _, _, completionHandler in
            self.setDefaultTaskList(taskList, at: indexPath, completionHandler: completionHandler)
        }
        return UISwipeActionsConfiguration(actions: [setDefaultAction])
    }
    
    private func setDefaultTaskList(_ taskList: TaskList, at indexPath: IndexPath, completionHandler: @escaping (Bool) -> Void) {
        showFioriLoadingIndicator()
        logger.info("Setting default task list in backend.")
        model.setObjectAsDefault(taskList) { topIndexPath, error in
            self.hideFioriLoadingIndicator()
            if let error = error {
                self.logger.error("Set default task list failed. Error: \(error)", error: error)
                AlertHelper.displayAlert(with: LocalizedStrings.OnlineOData.errorSetDefaultTaskListTitle, error: error, viewController: self)
                completionHandler(false)
                return
            }
            if let topIndexPath = topIndexPath {
                self.logger.info("Set default task list finished successfully.")
                DispatchQueue.main.async {
                    completionHandler(true)
                    self.tableView.moveRow(at: indexPath, to: topIndexPath)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let taskList = model.object(at: indexPath)
        guard taskList.isEditable else {
            return nil
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: LocalizedStrings.TaskListView.deleteActionTitle) { _, _, completionHandler in
            self.deleteTaskList(at: indexPath, completionHandler: completionHandler)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    private func deleteTaskList(at indexPath: IndexPath, completionHandler: @escaping (Bool) -> Void) {
        showFioriLoadingIndicator()
        logger.info("Deleting task collection in backend.")
        model.removeObject(at: indexPath) { error in
            self.hideFioriLoadingIndicator()
            if let error = error {
                self.logger.error("Delete task collection failed. Error: \(error)", error: error)
                AlertHelper.displayAlert(with: LocalizedStrings.OnlineOData.errorEntityDeletionTitle, error: error, viewController: self)
                completionHandler(false)
                return
            }
            self.logger.info("Delete task collection finished successfully.")
            DispatchQueue.main.async {
                completionHandler(true)
                FUIToastMessage.show(message: LocalizedStrings.OnlineOData.entityDeletionBody)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                if self.selectedIndex == indexPath {
                    self.selectedIndex = nil
                }
                self.makeSelection()
            }
        }
    }
    
    // MARK: Handle highlighting of selected cell

    private func makeSelection() {
        if let selectedIndex = selectedIndex {
            tableView.selectRow(at: selectedIndex, animated: true, scrollPosition: .none)
            tableView.scrollToRow(at: selectedIndex, at: .none, animated: true)
        } else {
            selectDefault()
        }
    }

    private func selectDefault() {
        // Automatically select first element if we have two panels (iPhone plus and iPad only)
        if splitViewController!.isCollapsed || dataService == nil {
            return
        }
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
        selectTaskList(at: indexPath)
    }
    
    // MARK: Actions

    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "TaskCollections", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "TaskCollectionCreateViewController") as! UINavigationController
        navigationController.modalPresentationStyle = .popover
        navigationController.popoverPresentationController?.barButtonItem = sender
        
        let viewController = navigationController.viewControllers[0] as! TaskCollectionEditViewController
        let collection = TaskCollections()
        collection.id = GuidValue.random()
        viewController.collection = collection
        viewController.delegate = self
        
        present(navigationController, animated: true)
    }
    
}

extension TaskListsViewController: TaskCollectionEditViewControllerDelegate {
    
    func taskCollectionViewController(_ viewController: TaskCollectionEditViewController, didEndEditing taskCollection: TaskCollections) {
        showFioriLoadingIndicator()
        logger.info("Creating task collection in backend.")
        model.appendObject(taskCollection) { indexPath, error in
            self.hideFioriLoadingIndicator()
            if let error = error {
                self.logger.error("Create task collection failed. Error: \(error)", error: error)
                AlertHelper.displayAlert(with: LocalizedStrings.OnlineOData.errorEntityCreationTitle, error: error, viewController: self)
                return
            }
            if let indexPath = indexPath {
                self.logger.info("Create task collection finished successfully.")
                DispatchQueue.main.async {
                    viewController.dismiss(animated: true) {
                        FUIToastMessage.show(message: LocalizedStrings.OnlineOData.entityCreationBody)
                        self.tableView.insertRows(at: [indexPath], with: .automatic)
                    }
                }
            }
        }
    }
    
}

fileprivate extension TaskList {
    
    var icon: UIImage {
        switch type {
        case .myDay:
            return FUIIconLibrary.system.clock
        case .tomorrow:
            return FUIIconLibrary.system.calendar
        case .collection:
            return FUIIconLibrary.system.listView
        }
    }
    
}
