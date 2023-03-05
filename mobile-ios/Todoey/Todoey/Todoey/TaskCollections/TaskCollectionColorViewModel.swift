//
//  TaskCollectionColorViewModel.swift
//  Todoey
//
//  Created by Witt, Robert on 05.03.23.
//  Copyright © 2023 SAP. All rights reserved.
//

import UIKit
import SAPFiori

class TaskCollectionColorViewModel {
    
    var colorNames = [
        LocalizedStrings.TaskCollectionColor.blue,
        LocalizedStrings.TaskCollectionColor.teal,
        LocalizedStrings.TaskCollectionColor.green,
        LocalizedStrings.TaskCollectionColor.mango,
        LocalizedStrings.TaskCollectionColor.red,
        LocalizedStrings.TaskCollectionColor.pink,
        LocalizedStrings.TaskCollectionColor.indigo,
        LocalizedStrings.TaskCollectionColor.grey
    ]
    
    private let colors = [
        UIColor.preferredFioriColor(forStyle: .blue4),
        UIColor.preferredFioriColor(forStyle: .teal4),
        UIColor.preferredFioriColor(forStyle: .green4),
        UIColor.preferredFioriColor(forStyle: .mango4),
        UIColor.preferredFioriColor(forStyle: .red4),
        UIColor.preferredFioriColor(forStyle: .pink4),
        UIColor.preferredFioriColor(forStyle: .indigo4),
        UIColor.preferredFioriColor(forStyle: .grey4)
    ]
    
    var selectedColorIndices = [Int]()
    var selectedColorName: String {
        guard let index = selectedColorIndices.first else {
            return LocalizedStrings.TaskCollectionColor.none
        }
        return colorNames[index]
    }
    
    var selectedColor: UIColor? {
        guard let index = selectedColorIndices.first else {
            return nil
        }
        return colors[index]
    }
    
    init(color: UIColor?) {
        guard let color = color, let index = colors.firstIndex(of: color) else {
            return
        }
        selectedColorIndices = [index]
    }
    
}
