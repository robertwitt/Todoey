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
        tableView.register(FUIObjectTableViewCell.self, forCellReuseIdentifier: FUIObjectTableViewCell.reuseIdentifier)
        tableView.register(FUIButtonFormCell.self, forCellReuseIdentifier: FUIButtonFormCell.reuseIdentifier)
        
        tableView.estimatedSectionHeaderHeight = 10
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        
        tableView.setEditing(true, animated: false)
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
            return task.subTasks.count + 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch Section(rawValue: section) {
        case .subTasks:
            return LocalizedStrings.Model.taskSubTasks
        default:
            return nil
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
    
    private func referencedOrDefaultCollection(_ collection: TaskCollections) -> Bool {
        guard let collectionID = task.collectionID else {
            return collection.isDefault_ ?? false
        }
        return collectionID == collection.id
    }
    
    private func subTaskCell(forRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < task.subTasks.count else {
            let cell = tableView.dequeueReusableCell(withIdentifier: FUIButtonFormCell.reuseIdentifier, for: indexPath as IndexPath) as! FUIButtonFormCell
            cell.button.titleLabel?.text = LocalizedStrings.TaskView.addSubTaskTitle
            cell.button.addTarget(self, action: #selector(addSubTaskPressed), for: .touchUpInside)
            return cell
        }
        
        let subTask = task.subTasks[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FUIObjectTableViewCell.reuseIdentifier, for: indexPath as IndexPath) as! FUIObjectTableViewCell
        cell.iconImages = [subTask.checkmark.withRenderingMode(.alwaysTemplate)]
        cell.headlineText = subTask.title
        
        return cell
    }
    
    @objc func addSubTaskPressed() {
        let alert = UIAlertController(title: LocalizedStrings.TaskView.addSubTaskTitle, message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = LocalizedStrings.TaskView.subTaskTitlePlaceholder
        }
        
        let action = UIAlertAction(title: LocalizedStrings.TaskView.addSubTaskCloseButtonTitle, style: .default) { _ in
            guard let textField = alert.textFields?[0], let text = textField.text, !text.isEmpty else {
                return
            }
            let subTask = SubTask()
            subTask.title = text
            let indexPath = IndexPath(row: self.task.subTasks.count, section: Section.subTasks.rawValue)
            self.task.subTasks.append(subTask)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        }
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    // MARK: Table view delegate
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard Section(rawValue: indexPath.section) == .subTasks else {
            return indexPath
        }
        let subTask = task.subTasks[indexPath.row]
        subTask.isDone = !(subTask.isDone ?? false)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return isSubTaskRow(at: indexPath)
    }
    
    private func isSubTaskRow(at indexPath: IndexPath) -> Bool {
        return Section(rawValue: indexPath.section) == .subTasks && indexPath.row < task.subTasks.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete && Section(rawValue: indexPath.section) == .subTasks else {
            return
        }
        task.subTasks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return isSubTaskRow(at: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard isSubTaskRow(at: destinationIndexPath) && sourceIndexPath != destinationIndexPath else {
            return
        }
        task.subTasks.insert(task.subTasks.remove(at: sourceIndexPath.row), at: destinationIndexPath.row)
        tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
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
