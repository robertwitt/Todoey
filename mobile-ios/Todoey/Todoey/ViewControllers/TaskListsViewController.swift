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
            AlertHelper.displayAlert(with: LocalizedStrings.Onboarding.oDataServiceFailedMessage, error: nil, viewController: self)
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
                AlertHelper.displayAlert(with: NSLocalizedString("keyErrorLoadingData", value: "Loading data failed!", comment: "XTIT: Title of loading data error pop up."), error: error, viewController: self)
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
        // TODO collectionSelected(at: indexPath)
    }

//    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
//        handleClick(at: indexPath)
//    }
//
//    private func handleClick(at indexPath: IndexPath) {
//        let selectedODataService = odataServiceNames[indexPath.row]
//        let collectionStoryBoard = UIStoryboard(name: selectedODataService, bundle: nil)
//        let collectionViewController = collectionStoryBoard.instantiateViewController(withIdentifier: "\(selectedODataService)CollectionsView")
//        navigationController?.pushViewController(collectionViewController, animated: true)
//    }
    
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
