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
        let objectHeader = FUIObjectHeader()
        objectHeader.headlineText = task.title
        objectHeader.subheadlineText = task.collection?.title
        objectHeader.statusImage = task.priorityIcon
        objectHeader.substatusText = task.formattedDueDateTime
        objectHeader.substatusLabel.textColor = task.isOverdue ? .preferredFioriColor(forStyle: .criticalLabel) : nil
        tableView.tableHeaderView = objectHeader
        
        tableView.register(FUIButtonFormCell.self, forCellReuseIdentifier: FUIButtonFormCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        //tableView.separatorStyle = .none
    }
    
    // MARK: Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Row.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FUIButtonFormCell.reuseIdentifier, for: indexPath) as! FUIButtonFormCell
        switch Row(rawValue: indexPath.row) {
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
        showFioriLoadingIndicator()
        logger.info("(Un-)Planning task for my day in backend.")
        
        task.isPlannedForMyDay = !(task.isPlannedForMyDay ?? false)
        
        dataService.updateEntity(task, headers: requestHeaders) { error in
            self.hideFioriLoadingIndicator()
            if let error = error {
                self.logger.error("Un-)Planning task for my day failed. Error: \(error)", error: error)
                AlertHelper.displayAlert(with: LocalizedStrings.OnlineOData.errorEntityUpdateTitle, error: error, viewController: self)
                return
            }
            self.logger.info("Un-)Planning task for my day finished successfully.")
            DispatchQueue.main.async {
                FUIToastMessage.show(message: LocalizedStrings.OnlineOData.entityUpdateBody)
                self.tableView.reloadData()
                self.postNotification(name: .taskUpdated)
            }
        }
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
    
}

fileprivate enum Row: Int {
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
