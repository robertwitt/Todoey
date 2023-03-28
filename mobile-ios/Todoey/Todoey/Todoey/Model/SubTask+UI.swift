//
//  SubTask+UI.swift
//  Todoey
//
//  Created by Witt, Robert on 28.03.23.
//  Copyright © 2023 SAP. All rights reserved.
//

import UIKit
import SAPFiori
import TaskServiceFmwk

extension SubTask {
    
    var checkmark: UIImage {
        guard let isDone = isDone, isDone else {
            return UIImage()
        }
        return FUIIconLibrary.system.check
    }
    
}
