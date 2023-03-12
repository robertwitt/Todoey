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
    var taskList: TaskList! {
        didSet {
            tasks = taskList.tasks
        }
    }
    var loadingIndicator: FUILoadingIndicatorView?

    private var tasks = [Tasks]()
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
        let index = tasks.firstIndex { $0.id == task.id }
        
        if !taskList.shouldList(task: task), let index = index {
            // Delete rows
            tasks.remove(at: index)
            tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            return
        }
        
        if let index = index {
            // Update row
            tasks[index] = task
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        } else {
            // Add row
            tasks.append(task)
            tableView.insertRows(at: [IndexPath(row: tasks.count - 1, section: 0)], with: .automatic)
        }
    }
    
    @objc func taskRemoved(_ notification: Notification) {
        guard let task = notification.userInfo?["Task"] as? Tasks else {
            return
        }
        let index = tasks.firstIndex { $0.id == task.id }
        guard let index = index else {
            return
        }
        tasks.remove(at: index)
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
    }

    // MARK: Table view data source

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = tasks[indexPath.row]
        
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
//        else if segue.identifier == "addEntity" {
//            // Show the Detail view with a new Entity, which can be filled to create on the server
//            logger.info("Showing view to add new entity.")
//            let dest = segue.destination as! UINavigationController
//            let detailViewController = dest.viewControllers[0] as! TasksDetailViewController
//            detailViewController.title = NSLocalizedString("keyAddEntityTitle", value: "Add Entity", comment: "XTIT: Title of add new entity screen.")
//            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: detailViewController, action: #selector(detailViewController.createEntity))
//            detailViewController.navigationItem.rightBarButtonItem = doneButton
//            let cancelButton = UIBarButtonItem(title: NSLocalizedString("keyCancelButtonToGoPreviousScreen", value: "Cancel", comment: "XBUT: Title of Cancel button."), style: .plain, target: detailViewController, action: #selector(detailViewController.cancel))
//            detailViewController.navigationItem.leftBarButtonItem = cancelButton
//            detailViewController.allowsEditableCells = true
//            detailViewController.tableUpdater = self
//            detailViewController.dataService = dataService
//            detailViewController.entitySetName = entitySetName
//        }
    }

}
