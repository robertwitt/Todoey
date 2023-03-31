//
//  TaskCollectionEditViewController.swift
//  Todoey
//
//  Created by Witt, Robert on 05.03.23.
//  Copyright © 2023 SAP. All rights reserved.
//

import UIKit
import SAPFiori
import TaskServiceFmwk

class TaskCollectionEditViewController: FUIFormTableViewController {
    
    var delegate: TaskCollectionEditViewControllerDelegate?
    var collection: TaskCollections!
    
    private var colorModel: TaskCollectionColorViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        colorModel = TaskCollectionColorViewModel(color: collection?.displayColor)
    }
    
    private func setupTableView() {
        tableView.register(FUITextFieldFormCell.self, forCellReuseIdentifier: FUITextFieldFormCell.reuseIdentifier)
        tableView.register(FUIListPickerFormCell.self, forCellReuseIdentifier: FUIListPickerFormCell.reuseIdentifier)
        tableView.register(FUISwitchFormCell.self, forCellReuseIdentifier: FUISwitchFormCell.reuseIdentifier)
                
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
    }

    // MARK: Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Row.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Row(rawValue: indexPath.row) {
        case .title:
            let cell = tableView.dequeueReusableCell(withIdentifier: FUITextFieldFormCell.reuseIdentifier, for: indexPath) as! FUITextFieldFormCell
            cell.keyName = LocalizedStrings.Model.taskListTitle
            cell.value = collection?.title ?? ""
            cell.valueTextField.delegate = self
            cell.isStacked = false
            return cell
        case .color:
            let cell = tableView.dequeueReusableCell(withIdentifier: FUIListPickerFormCell.reuseIdentifier, for: indexPath) as! FUIListPickerFormCell
            cell.keyName = LocalizedStrings.Model.taskListColor
            cell.value = colorModel.selectedColorIndices
            cell.valueLabel.text = colorModel.selectedColorName
            cell.valueLabel.textColor = colorModel.selectedColor
            cell.valueOptions = colorModel.colorNames
            cell.allowsMultipleSelection = false
            cell.allowsEmptySelection = true
            cell.accessoryType = .disclosureIndicator
            cell.onChangeHandler = { [weak self] newValues in
                self?.colorModel.selectedColorIndices = newValues
                self?.collection?.displayColor = self?.colorModel.selectedColor
            }
            return cell
        case .isDefault:
            let cell = tableView.dequeueReusableCell(withIdentifier: FUISwitchFormCell.reuseIdentifier, for: indexPath) as! FUISwitchFormCell
            cell.keyName = LocalizedStrings.Model.taskListIsDefault
            cell.value = collection?.isDefault ?? false
            cell.isEditable = false
            return cell
        default:
            return UITableViewCell()
        }
    }

    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        delegate?.taskCollectionViewController(self, didEndEditing: collection)
    }
    
}

extension TaskCollectionEditViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let range = Range(range, in: text) {
            collection?.title = text.replacingCharacters(in: range, with: string)
        }
        return true
    }
    
}

protocol TaskCollectionEditViewControllerDelegate {
    func taskCollectionViewController(_ viewController: TaskCollectionEditViewController, didEndEditing taskCollection: TaskCollections)
}

fileprivate enum Row: Int {
    case title = 0
    case color = 1
    case isDefault = 2
    static let count = 3
}
