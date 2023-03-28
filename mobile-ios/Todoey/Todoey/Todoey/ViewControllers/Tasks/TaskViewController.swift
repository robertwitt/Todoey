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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        updateTableViewHeader()
        tableView.register(FUIObjectTableViewCell.self, forCellReuseIdentifier: FUIObjectTableViewCell.reuseIdentifier)
        tableView.register(FUIButtonFormCell.self, forCellReuseIdentifier: FUIButtonFormCell.reuseIdentifier)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func updateTableViewHeader() {
        let objectHeader = FUIObjectHeader()
        objectHeader.headlineText = task.title
        objectHeader.subheadlineText = task.collection?.title
        objectHeader.statusImage = task.priorityIcon
        objectHeader.substatusText = task.formattedDueDateTime
        objectHeader.substatusLabel.textColor = task.isOverdue ? .preferredFioriColor(forStyle: .criticalLabel) : nil
        tableView.tableHeaderView = objectHeader
    }
    
    // MARK: Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .subTasks:
            return task.subTasks.count
        case .actions:
            return ActionRow.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section) {
        case .subTasks:
            return subTaskCell(forRowAt: indexPath)
        case .actions:
            return actionCell(forRowAt: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    private func subTaskCell(forRowAt indexPath: IndexPath) -> UITableViewCell {
        let subTask = task.subTasks[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FUIObjectTableViewCell.reuseIdentifier, for: indexPath as IndexPath) as! FUIObjectTableViewCell
        cell.iconImages = [subTask.checkmark.withRenderingMode(.alwaysTemplate)]
        cell.headlineText = subTask.title
        
        return cell
    }
    
    private func actionCell(forRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FUIButtonFormCell.reuseIdentifier, for: indexPath) as! FUIButtonFormCell
        switch ActionRow(rawValue: indexPath.row) {
        case .myDay:
            cell.button.titleLabel?.text = (task.isPlannedForMyDay ?? false) ? LocalizedStrings.TaskView.removeFromMyDayTitle : LocalizedStrings.TaskView.addToMyDayTitle
            cell.button.addTarget(self, action: #selector(myDayPressed), for: .touchUpInside)
            return cell
        case .setDone:
            cell.button.titleLabel?.text = LocalizedStrings.TaskView.setDoneTitle
            cell.button.addTarget(self, action: #selector(setDonePressed), for: .touchUpInside)
            return cell
        case .delete:
            cell.button.titleLabel?.text = LocalizedStrings.TaskView.deleteTitle
            cell.button.addTarget(self, action: #selector(deletePressed), for: .touchUpInside)
            cell.setTintColor(.preferredFioriColor(forStyle: .negativeLabel), for: .normal)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    @objc func myDayPressed() {
        task.isPlannedForMyDay = !(task.isPlannedForMyDay ?? false)
        updateTask(task)
    }
    
    @objc func setDonePressed() {
        showFioriLoadingIndicator()
        logger.info("Setting task to done in backend.")
        
        dataService.setToDone(in: task, headers: requestHeaders) { error in
            self.hideFioriLoadingIndicator()
            if let error = error {
                self.logger.error("Setting task to done failed: Error: \(error)", error: error)
                AlertHelper.displayAlert(with: LocalizedStrings.OnlineOData.errorEntityUpdateTitle, error: error, viewController: self)
                return
            }
            self.logger.info("Setting task to done finished successfully.")
            DispatchQueue.main .async {
                FUIToastMessage.show(message: LocalizedStrings.OnlineOData.entityUpdateBody)
                self.postNotification(name: .taskRemoved)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc func deletePressed() {
        showFioriLoadingIndicator()
        logger.info("Deleting task in backend.")
        
        dataService.deleteEntity(task, headers: requestHeaders) { error in
            self.hideFioriLoadingIndicator()
            if let error = error {
                self.logger.error("Deleting task failed: Error: \(error)", error: error)
                AlertHelper.displayAlert(with: LocalizedStrings.OnlineOData.errorEntityDeletionTitle, error: error, viewController: self)
                return
            }
            self.logger.info("Deleting task finished successfully.")
            DispatchQueue.main .async {
                FUIToastMessage.show(message: LocalizedStrings.OnlineOData.entityDeletionBody)
                self.postNotification(name: .taskRemoved)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private var requestHeaders: HTTPHeaders {
        let headers = HTTPHeaders()
        headers.setHeader(withName: "If-Match", value: task.etag)
        return headers

    }
    
    private func postNotification(name: Notification.Name) {
        NotificationCenter.default.post(name: name, object: nil, userInfo: ["Task": self.task!])
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let viewController = navigationController.viewControllers[0] as! TaskEditViewController
        viewController.title = LocalizedStrings.TaskView.editTaskTitle
        viewController.task = task
        viewController.dataService = dataService
        viewController.delegate = self
    }
    
}

extension TaskViewController: TaskEditViewControllerDelegate {
    
    func taskViewController(_ viewController: TaskEditViewController, didEndEditing task: TaskServiceFmwk.Tasks) {
        updateTask(task, from: viewController)
    }
    
    private func updateTask(_ task: Tasks, from viewController: UIViewController? = nil) {
        showFioriLoadingIndicator()
        logger.info("Updating task in backend.")
        
        dataService.updateEntity(task, headers: requestHeaders) { error in
            self.hideFioriLoadingIndicator()
            if let error = error {
                self.logger.error("Update task failed. Error: \(error)", error: error)
                AlertHelper.displayAlert(with: LocalizedStrings.OnlineOData.errorEntityUpdateTitle, error: error, viewController: self)
                return
            }
            self.logger.info("Update task finished successfully.")
            DispatchQueue.main.async {
                viewController?.dismiss(animated: true)
                FUIToastMessage.show(message: LocalizedStrings.OnlineOData.entityUpdateBody)
                self.task = task
                self.updateTableViewHeader()
                self.tableView.reloadData()
                self.postNotification(name: .taskUpdated)
            }
        }
    }
    
}

fileprivate enum Section: Int {
    case subTasks = 0
    case actions = 1
    static let count = 2
}

fileprivate enum ActionRow: Int {
    case myDay = 0
    case setDone = 1
    case delete = 2
    static let count = 3
}

fileprivate extension Tasks {
    
    var etag: String {
        if let entityTag = entityTag {
            return entityTag
        }
        guard let lastModifiedAt = lastModifiedAt else {
            return ""
        }
        return "W/\"\(lastModifiedAt)\""
    }
    
}
