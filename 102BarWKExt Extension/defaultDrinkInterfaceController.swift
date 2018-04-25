//
//  defaultDrinkInterfaceController.swift
//  102BarWKExt Extension
//
//  Created by Justin Busse on 23.04.18.
//  Copyright © 2018 102 Bier. All rights reserved.
//

import WatchKit
import Foundation

class defaultDrinkInterfaceController: WKInterfaceController {

    @IBOutlet var tableView: WKInterfaceTable!
    var availableMixes = Service.shared.availableMixes
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        //loadTableData()
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
//        Service.shared.getAvailableMixes {
//            _ in
//            self.availableMixes = Service.shared.availableMixes
//            self.loadTableData()
//        }
        self.loadTableData()
        super.willActivate()
        //loadTableData()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func loadTableData() {
        
        availableMixes = Service.shared.availableMixes
        tableView.setNumberOfRows( availableMixes.count, withRowType: "defaultRowController")
        /*print("number of rows set: \(availableMixes.count)")*/
        /*if let defaultRowController = tableView.rowController(at: 0) as? defaultRowController
        {
            defaultRowController.mixLabel.setText(String(availableMixes.count))
        }
        if let defaultRowController = tableView.rowController(at: 1) as? defaultRowController
        {
            defaultRowController.mixLabel.setText("tschau")
        }*/
        
        for (index, rowModel) in availableMixes.enumerated() {
            
            if let defaultRowController = tableView.rowController(at: index) as? defaultRowController
            {
                defaultRowController.mixLabel.setText("hallo")//rowModel.mixDescription)
                print("row set \(rowModel.mixDescription)")
            }
        }
    }

}
