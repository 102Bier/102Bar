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
    
    var availableMixes : [Mix] = Array()

    override func awake(withContext context: Any?) {
        if let checkContext = context
        {
            availableMixes = checkContext as! [Mix]
        }
        super.awake(withContext: context)
        loadTableData()
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func loadTableData() {
        tableView.setNumberOfRows( availableMixes.count, withRowType: "defaultRowController")
        for (index, rowModel) in availableMixes.enumerated() {
            
            if let defaultRowController = tableView.rowController(at: index) as? defaultRowController
            {
                defaultRowController.mixLabel.setText(rowModel.mixDescription)
                //print("row set \(rowModel.mixDescription)")
            }
        }
    }

}
