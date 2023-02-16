//
// Todoey
//
// Created by SAP BTP SDK Assistant for iOS v9.0.4 application on 14/02/23
//

import SAPFiori
import SAPFioriFlows
import SAPFoundation
import SAPOData

import SharedFmwk
import TaskServiceFmwk

protocol TaskServiceEntityUpdaterDelegate {
    func entityHasChanged(_ entity: EntityValue?)
}

protocol TaskServiceEntitySetUpdaterDelegate {
    func entitySetHasChanged()
}

class TaskServiceCollectionsViewController: FUIFormTableViewController {
    private var collections = TaskServiceCollectionType.allCases

    // Variable to store the selected index path
    private var selectedIndex: IndexPath?

    private let okTitle = NSLocalizedString("keyOkButtonTitle",
                                            value: "OK",
                                            comment: "XBUT: Title of OK button.")

    var isPresentedInSplitView: Bool {
        return !(self.splitViewController?.isCollapsed ?? true)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = CGSize(width: 320, height: 480)

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        makeSelection()
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

    // MARK: - UITableViewDelegate

    override func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return collections.count
    }

    override func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 44
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FUIObjectTableViewCell.reuseIdentifier, for: indexPath) as! FUIObjectTableViewCell
        cell.headlineLabel.text = collections[indexPath.row].description
        cell.accessoryType = !isPresentedInSplitView ? .disclosureIndicator : .none
        cell.isMomentarySelection = false
        return cell
    }

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        collectionSelected(at: indexPath)
    }

    // CollectionType selection helper
    private func collectionSelected(at indexPath: IndexPath) {
        // Load the EntityType specific ViewController from the specific storyboard"
        var masterViewController: UIViewController!
        guard let odataController = OnboardingSessionManager.shared.onboardingSession?.odataControllers[ODataContainerType.taskService.description] as? TaskServiceOnlineODataController, let dataService = odataController.dataService else {
            AlertHelper.displayAlert(with: "OData service is not reachable, please onboard again.", error: nil, viewController: self)
            return
        }
        selectedIndex = indexPath

        switch collections[indexPath.row] {
        case .taskPriorities:
            let taskPrioritiesStoryBoard = UIStoryboard(name: "TaskPriorities", bundle: nil)
            let taskPrioritiesMasterViewController = taskPrioritiesStoryBoard.instantiateViewController(withIdentifier: "TaskPrioritiesMaster") as! TaskPrioritiesMasterViewController
            taskPrioritiesMasterViewController.dataService = dataService
            taskPrioritiesMasterViewController.entitySetName = "TaskPriorities"
            func fetchTaskPriorities(_ completionHandler: @escaping ([TaskServiceFmwk.TaskPriorities]?, Error?) -> Void) {
                // Only request the first 20 values. If you want to modify the requested entities, you can do it here.
                let query = DataQuery().selectAll().top(20)
                do {
                    dataService.fetchTaskPriorities(matching: query, completionHandler: completionHandler)
                }
            }
            taskPrioritiesMasterViewController.loadEntitiesBlock = fetchTaskPriorities
            taskPrioritiesMasterViewController.navigationItem.title = "TaskPriorities"
            masterViewController = taskPrioritiesMasterViewController
        case .tasks:
            let tasksStoryBoard = UIStoryboard(name: "Tasks", bundle: nil)
            let tasksMasterViewController = tasksStoryBoard.instantiateViewController(withIdentifier: "TasksMaster") as! TasksMasterViewController
            tasksMasterViewController.dataService = dataService
            tasksMasterViewController.entitySetName = "Tasks"
            func fetchTasks(_ completionHandler: @escaping ([TaskServiceFmwk.Tasks]?, Error?) -> Void) {
                // Only request the first 20 values. If you want to modify the requested entities, you can do it here.
                let query = DataQuery().selectAll().top(20)
                do {
                    dataService.fetchTasks(matching: query, completionHandler: completionHandler)
                }
            }
            tasksMasterViewController.loadEntitiesBlock = fetchTasks
            tasksMasterViewController.navigationItem.title = "Tasks"
            masterViewController = tasksMasterViewController
        case .taskPrioritiesTexts:
            let taskPrioritiesTextsStoryBoard = UIStoryboard(name: "TaskPrioritiesTexts", bundle: nil)
            let taskPrioritiesTextsMasterViewController = taskPrioritiesTextsStoryBoard.instantiateViewController(withIdentifier: "TaskPrioritiesTextsMaster") as! TaskPrioritiesTextsMasterViewController
            taskPrioritiesTextsMasterViewController.dataService = dataService
            taskPrioritiesTextsMasterViewController.entitySetName = "TaskPrioritiesTexts"
            func fetchTaskPrioritiesTexts(_ completionHandler: @escaping ([TaskServiceFmwk.TaskPrioritiesTexts]?, Error?) -> Void) {
                // Only request the first 20 values. If you want to modify the requested entities, you can do it here.
                let query = DataQuery().selectAll().top(20)
                do {
                    dataService.fetchTaskPrioritiesTexts(matching: query, completionHandler: completionHandler)
                }
            }
            taskPrioritiesTextsMasterViewController.loadEntitiesBlock = fetchTaskPrioritiesTexts
            taskPrioritiesTextsMasterViewController.navigationItem.title = "TaskPrioritiesTexts"
            masterViewController = taskPrioritiesTextsMasterViewController
        case .taskCollections:
            let taskCollectionsStoryBoard = UIStoryboard(name: "TaskCollections", bundle: nil)
            let taskCollectionsMasterViewController = taskCollectionsStoryBoard.instantiateViewController(withIdentifier: "TaskCollectionsMaster") as! TaskCollectionsMasterViewController
            taskCollectionsMasterViewController.dataService = dataService
            taskCollectionsMasterViewController.entitySetName = "TaskCollections"
            func fetchTaskCollections(_ completionHandler: @escaping ([TaskServiceFmwk.TaskCollections]?, Error?) -> Void) {
                // Only request the first 20 values. If you want to modify the requested entities, you can do it here.
                let query = DataQuery().selectAll().top(20)
                do {
                    dataService.fetchTaskCollections(matching: query, completionHandler: completionHandler)
                }
            }
            taskCollectionsMasterViewController.loadEntitiesBlock = fetchTaskCollections
            taskCollectionsMasterViewController.navigationItem.title = "TaskCollections"
            masterViewController = taskCollectionsMasterViewController
        @unknown default:
            masterViewController = UIViewController()
        }

        // Load the NavigationController and present with the EntityType specific ViewController
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let rightNavigationController = mainStoryBoard.instantiateViewController(withIdentifier: "RightNavigationController") as! UINavigationController
        rightNavigationController.viewControllers = [masterViewController]
        splitViewController?.showDetailViewController(rightNavigationController, sender: nil)
    }

    // MARK: - Handle highlighting of selected cell

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
        guard let odataController = OnboardingSessionManager.shared.onboardingSession?.odataControllers[ODataContainerType.taskService.description] as? TaskServiceOnlineODataController else {
            AlertHelper.displayAlert(with: "OData service is not reachable, please onboard again.", error: nil, viewController: self)
            return
        }

        if splitViewController!.isCollapsed || odataController.dataService == nil {
            return
        }
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
        collectionSelected(at: indexPath)
    }

    static func entitySet(withName entitySetName: String?) -> EntitySet? {
        switch entitySetName {
        case "TaskPriorities": return TaskServiceMetadata.EntitySets.taskPriorities
        case "Tasks": return TaskServiceMetadata.EntitySets.tasks
        case "TaskPrioritiesTexts": return TaskServiceMetadata.EntitySets.taskPrioritiesTexts
        case "TaskCollections": return TaskServiceMetadata.EntitySets.taskCollections
        default: return nil
        }
    }
}
