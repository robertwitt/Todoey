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
    }
    
    private func setupNavigationItem() {
        navigationItem.title = taskList.title
    }
    
    private func setupTableView() {
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(FUIObjectTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
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

    // MARK: Segues

//    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
//        if segue.identifier == "showDetail" {
//            // Show the selected Entity on the Detail view
//            guard let indexPath = tableView.indexPathForSelectedRow else {
//                return
//            }
//            logger.info("Showing details of the chosen element.")
//            let selectedEntity = entities[indexPath.row]
//            let detailViewController = segue.destination as! TasksDetailViewController
//            detailViewController.entity = selectedEntity
//            detailViewController.navigationItem.leftItemsSupplementBackButton = true
//            detailViewController.navigationItem.title = "\(entities[(tableView.indexPathForSelectedRow?.row)!].id != nil ? "\(entities[(tableView.indexPathForSelectedRow?.row)!].id!)" : "")"
//            detailViewController.allowsEditableCells = false
//            detailViewController.tableUpdater = self
//            detailViewController.preventNavigationLoop = preventNavigationLoop
//            detailViewController.dataService = dataService
//            detailViewController.entitySetName = entitySetName
//        } else if segue.identifier == "addEntity" {
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
//    }

}

fileprivate extension Tasks {
    
    var priorityIcon: UIImage {
        guard let priorityCode = priority?.code else {
            return UIImage()
        }
        switch priorityCode {
        case 1:
            return FUIIconLibrary.indicator.veryHighPriority
        case 3:
            return FUIIconLibrary.indicator.highPriority
        case 5:
            return FUIIconLibrary.indicator.mediumPriority
        default:
            return UIImage()
        }
    }
    
    var dueDateTime: Date? {
        guard let dueDate = dueDate else {
            return nil
        }
        let dateComponents = DateComponents(year: dueDate.year,
                                            month: dueDate.month,
                                            day: dueDate.day,
                                            hour: dueTime?.hour,
                                            minute: dueTime?.minute,
                                            second: dueTime?.second)
        return Calendar.current.date(from: dateComponents)
    }
    
    var formattedDueDateTime: String? {
        guard let dateTime = dueDateTime else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: dateTime)
    }
    
    var isOverdue: Bool {
        guard let dueDateTime = dueDateTime else {
            return false
        }
        return dueDateTime < Date.now
    }
    
}
