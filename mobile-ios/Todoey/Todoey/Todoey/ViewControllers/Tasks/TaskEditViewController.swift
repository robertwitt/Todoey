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

class TaskEditViewController: FUIFormTableViewController, SAPFioriLoadingIndicator {
    
    var dataService: TaskService<OnlineODataProvider>!
    var task: Tasks!
    var loadingIndicator: FUILoadingIndicatorView?
    var delegate: TaskEditViewControllerDelegate?
    
    private var taskCollections = [TaskCollections]()
    private var taskPriorities = [TaskPriorities]()
    private let logger = Logger.shared(named: "TaskViewControllerLogger")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        updateValueHelps()
    }
    
    private func setupTableView() {
        tableView.register(FUITextFieldFormCell.self, forCellReuseIdentifier: FUITextFieldFormCell.reuseIdentifier)
        tableView.register(FUIListPickerFormCell.self, forCellReuseIdentifier: FUIListPickerFormCell.reuseIdentifier)
        tableView.register(FUIValuePickerFormCell.self, forCellReuseIdentifier: FUIValuePickerFormCell.reuseIdentifier)
        tableView.register(FUIDatePickerFormCell.self, forCellReuseIdentifier: FUIDatePickerFormCell.reuseIdentifier)
        tableView.register(FUISwitchFormCell.self, forCellReuseIdentifier: FUISwitchFormCell.reuseIdentifier)
        
        tableView.estimatedSectionHeaderHeight = 10
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
    }
    
    // MARK: Load data
    
    private func updateValueHelps() {
        showFioriLoadingIndicator()
        DispatchQueue.global().async {
            self.loadValueHelps {
                self.hideFioriLoadingIndicator()
            }
        }
    }
    
    private func loadValueHelps(completionHandler: @escaping () -> Void) {
        requestValueHelps { error in
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
    
    private func requestValueHelps(completionHandler: @escaping (Error?) -> Void) {
        taskCollections = []
        taskPriorities = []
        
        let batch = RequestBatch()
        let queryCollections = DataQuery()
            .from(dataService.entitySet(withName: "TaskCollections"))
            .select(TaskCollections.id, TaskCollections.title, TaskCollections.isDefault_)
            .orderBy(TaskCollections.title)
        batch.addQuery(queryCollections)
        let queryPriorities = DataQuery()
            .from(dataService.entitySet(withName: "TaskPriorities"))
            .select(TaskPriorities.code, TaskPriorities.name)
            .orderBy(TaskPriorities.code)
        batch.addQuery(queryPriorities)
        
        dataService.processBatch(batch) { error in
            if let error = error {
                completionHandler(error)
            }
            do {
                self.taskCollections = try batch.queryResult(for: queryCollections).entityList().toArray() as! [TaskCollections]
                self.taskPriorities = try batch.queryResult(for: queryPriorities).entityList().toArray() as! [TaskPriorities]
                completionHandler(nil)
            } catch {
                completionHandler(error)
            }
            
        }
    }
    
    // MARK: Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .header:
            return HeaderRow.count
        case .subTasks:
            return task.subTasks.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section) {
        case .header:
            return headerCell(forRowAt: indexPath)
        case .subTasks:
            return subTaskCell(forRowAt: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    private func headerCell(forRowAt indexPath: IndexPath) -> UITableViewCell {
        switch HeaderRow(rawValue: indexPath.row) {
        case .title:
            let cell = tableView.dequeueReusableCell(withIdentifier: FUITextFieldFormCell.reuseIdentifier, for: indexPath) as! FUITextFieldFormCell
            cell.keyName = LocalizedStrings.Model.taskTitle
            cell.value = task.title ?? ""
            cell.valueTextField.delegate = self
            cell.isEditable = true
            cell.isStacked = false
            return cell
        case .collection:
            let cell = tableView.dequeueReusableCell(withIdentifier: FUIListPickerFormCell.reuseIdentifier, for: indexPath) as! FUIListPickerFormCell
            cell.keyName = LocalizedStrings.Model.taskCollection
            cell.value = taskCollections.count == 0 ? [] : [taskCollections.firstIndex(where: referencedOrDefaultCollection(_:))!]
            cell.isEditable = true
            cell.allowsMultipleSelection = false
            cell.allowsEmptySelection = false
            cell.valueLabel.text = task.collection?.title
            cell.valueOptions = taskCollections.map { $0.title ?? "" }
            cell.onChangeHandler = { newValues in
                let collection = self.taskCollections[newValues[0]]
                self.task.collectionID = collection.id
                self.task.collection = collection
            }
            return cell
        case .priority:
            let cell = tableView.dequeueReusableCell(withIdentifier: FUIValuePickerFormCell.reuseIdentifier, for: indexPath) as! FUIValuePickerFormCell
            cell.keyName = LocalizedStrings.Model.taskPriority
            cell.value = taskPriorities.count == 0 ? 0 : (taskPriorities.firstIndex { $0.code == task.priorityCode } ?? -1) + 1
            cell.valueOptions = [""] + taskPriorities.map { $0.name ?? "" }
            cell.onChangeHandler = { valueIndex in
                let priority = valueIndex == 0 ? nil : self.taskPriorities[valueIndex - 1]
                self.task.priorityCode = priority?.code
                self.task.priority = priority
            }
            return cell
        case .dueDate:
            let cell = tableView.dequeueReusableCell(withIdentifier: FUIDatePickerFormCell.reuseIdentifier, for: indexPath) as! FUIDatePickerFormCell
            cell.keyName = LocalizedStrings.Model.taskDueDate
            cell.datePickerMode = .date
            if let dueDate = task.dueDate?.date {
                cell.value = dueDate
            }
            cell.onChangeHandler = { newValue in
                self.task.dueDate = LocalDate.from(utc: newValue)
            }
            return cell
        case .dueTime:
            let cell = tableView.dequeueReusableCell(withIdentifier: FUIDatePickerFormCell.reuseIdentifier, for: indexPath) as! FUIDatePickerFormCell
            cell.keyName = LocalizedStrings.Model.taskDueTime
            cell.datePickerMode = .time
            if let dueTime = task.dueTime?.date {
                cell.value = dueTime
            }
            cell.onChangeHandler = { newValue in
                self.task.dueTime = LocalTime.from(utc: newValue)
            }
            return cell
        case .isPlannedForMyDay:
            let cell = tableView.dequeueReusableCell(withIdentifier: FUISwitchFormCell.reuseIdentifier, for: indexPath) as! FUISwitchFormCell
            cell.keyName = LocalizedStrings.Model.taskIsPlannedForMyDay
            cell.value = task.isPlannedForMyDay ?? false
            cell.onChangeHandler = { newValue in
                self.task.isPlannedForMyDay = newValue
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    private func subTaskCell(forRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    private func referencedOrDefaultCollection(_ collection: TaskCollections) -> Bool {
        guard let collectionID = task.collectionID else {
            return collection.isDefault_ ?? false
        }
        return collectionID == collection.id
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        delegate?.taskViewController(self, didEndEditing: task)
    }
    
}

extension TaskEditViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let range = Range(range, in: text) {
            task?.title = text.replacingCharacters(in: range, with: string)
        }
        return true
    }
    
}

protocol TaskEditViewControllerDelegate {
    func taskViewController(_ viewController: TaskEditViewController, didEndEditing task: Tasks)
}

fileprivate enum Section: Int {
    case header = 0
    case subTasks = 1
    static let count = 2
}

fileprivate enum HeaderRow: Int {
    case title = 0
    case collection = 1
    case priority = 2
    case dueDate = 3
    case dueTime = 4
    case isPlannedForMyDay = 5
    static let count = 6
}
