//
//  TaskCollectionEditViewController.swift
//  Todoey
//
//  Created by Witt, Robert on 05.03.23.
//  Copyright © 2023 SAP. All rights reserved.
//

import UIKit
import SAPFiori

class TaskCollectionEditViewController: FUIFormTableViewController {
    
    private var colorModel: TaskCollectionColorViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        colorModel = TaskCollectionColorViewModel(color: nil)
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
            cell.value = ""
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
            }
            return cell
        case .isDefault:
            let cell = tableView.dequeueReusableCell(withIdentifier: FUISwitchFormCell.reuseIdentifier, for: indexPath) as! FUISwitchFormCell
            cell.keyName = LocalizedStrings.Model.taskListIsDefault
            cell.value = false
            cell.onChangeHandler = { newValue in
                
            }
            return cell
        default:
            return UITableViewCell()
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func savePressed(_ sender: Any) {
    }
    
}

extension TaskCollectionEditViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
}

fileprivate enum Row: Int {
    case title = 0
    case color = 1
    case isDefault = 2
    static let count = 3
}
