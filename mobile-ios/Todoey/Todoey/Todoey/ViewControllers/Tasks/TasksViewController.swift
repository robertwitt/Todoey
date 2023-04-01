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
    var taskList: TaskList!
    var loadingIndicator: FUILoadingIndicatorView?

    private let cellIdentifier = "TaskCell"
    private let logger = Logger.shared(named: "TasksViewControllerLogger")

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        setupTableView()
        setupObserver()
    }
    
    private func setupNavigationItem() {
        navigationItem.title = taskList.title
    }
    
    private func setupTableView() {
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(FUIObjectTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    private func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(taskUpdated), name: .taskUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(taskRemoved), name: .taskRemoved, object: nil)
    }
    
    @objc func taskUpdated(_ notification: Notification) {
        guard let task = notification.userInfo?["Task"] as? Tasks else {
            return
        }
        updateTaskListAfterUpdating(task: task)
    }
    
    private func updateTaskListAfterUpdating(task: Tasks) {
        taskList.onTaskUpdated(task, postProcessor: self)
        postTaskListUpdatedNotification()
    }
    
    @objc func taskRemoved(_ notification: Notification) {
        guard let task = notification.userInfo?["Task"] as? Tasks else {
            return
        }
        taskList.onTaskRemoved(task, postProcessor: self)
        postTaskListUpdatedNotification()
    }
    
    private func postTaskListUpdatedNotification() {
        NotificationCenter.default.post(name: .taskListUpdated, object: nil, userInfo: ["TaskList": taskList!])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
    }

    // MARK: Table view data source

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return taskList.tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = taskList.tasks[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! FUIObjectTableViewCell
        cell.iconImages = [task.priorityIcon.withRenderingMode(.alwaysTemplate)]
        cell.headlineText = task.title
        cell.subheadlineText = task.collection?.title
        cell.statusText = task.formattedDueDateTime
        cell.statusLabel.textColor = task.isOverdue ? .preferredFioriColor(forStyle: .criticalLabel) : nil
        cell.accessoryType = .disclosureIndicator
        cell.splitPercent = CGFloat(0.3)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: tableView.cellForRow(at: indexPath)!)
    }

    // MARK: Segues

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if segue.identifier == "showDetail" {
            // Show the selected Entity on the Detail view
            guard let indexPath = tableView.indexPathForSelectedRow else {
                return
            }
            logger.info("Showing details of the chosen element.")
            let detailViewController = segue.destination as! TaskViewController
            detailViewController.dataService = dataService
            detailViewController.task = taskList.tasks[indexPath.row]
        }
        else if segue.identifier == "addEntity" {
            logger.info("Showing view to add new entity.")
            let navigationController = segue.destination as! UINavigationController
            let viewController = navigationController.viewControllers[0] as! TaskEditViewController
            viewController.title = LocalizedStrings.TaskView.createTaskTitle
            viewController.task = taskList.newTask()
            viewController.dataService = dataService
            viewController.delegate = self
        }
    }

}

extension TasksViewController: TaskEditViewControllerDelegate {
    
    func taskViewController(_ viewController: TaskEditViewController, didEndEditing task: TaskServiceFmwk.Tasks) {
        showFioriLoadingIndicator()
        logger.info("Creating task collection in backend.")
        
        dataService.createEntity(task) { error in
            self.hideFioriLoadingIndicator()
            if let error = error {
                self.logger.error("Create task failed. Error: \(error)", error: error)
                AlertHelper.displayAlert(with: LocalizedStrings.OnlineOData.errorEntityCreationTitle, error: error, viewController: self)
                return
            }
            self.logger.info("Create task finished successfully.")
            DispatchQueue.main.async {
                viewController.dismiss(animated: true) {
                    FUIToastMessage.show(message: LocalizedStrings.OnlineOData.entityCreationBody)
                    self.updateTaskListAfterUpdating(task: task)
                    NotificationCenter.default.post(name: .taskUpdated, object: nil, userInfo: ["Task": task])
                }
            }
        }
    }
    
}

extension TasksViewController: TaskEditPostProcessing {
    
    func afterInsert(at rowIndex: Int) {
        tableView.insertRows(at: [IndexPath(row: rowIndex, section: 0)], with: .automatic)
    }
    
    func afterUpdate(at rowIndex: Int) {
        tableView.reloadRows(at: [IndexPath(row: rowIndex, section: 0)], with: .automatic)
    }
    
    func afterDelete(at rowIndex: Int) {
        tableView.deleteRows(at: [IndexPath(row: rowIndex, section: 0)], with: .automatic)
    }
    
}
