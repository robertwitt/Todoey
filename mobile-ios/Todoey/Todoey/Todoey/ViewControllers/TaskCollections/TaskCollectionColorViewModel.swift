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
        UIColor(hexString: "1B90FFFF"),
        UIColor(hexString: "04ACA7FF"),
        UIColor(hexString: "36A41DFF"),
        UIColor(hexString: "F58B00FF"),
        UIColor(hexString: "EE3939FF"),
        UIColor(hexString: "F31DEDFF"),
        UIColor(hexString: "9B76FFFF"),
        UIColor(hexString: "8396A8FF")
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
