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
        
    }
    
    @objc func setDonePressed() {
        
    }
    
    @objc func deletePressed() {
        
    }
    
}

fileprivate enum Row: Int {
    case myDay = 0
    case setDone = 1
    case delete = 2
    static let count = 3
}
