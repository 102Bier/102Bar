//
//  customDrinksInterfaceController.swift
//  102BarWKExt Extension
//
//  Created by Justin Busse on 23.04.18.
//  Copyright © 2018 102 Bier. All rights reserved.
//

import WatchKit
import Foundation

class customDrinksInterfaceController: WKInterfaceController, WatchDataChangedDelegate{
    
    @IBOutlet var tableView: WKInterfaceTable!
    
    var customMixes : [Mix] = Array()
    
    override func awake(withContext context: Any?) {
        if context != nil
        {
            if (context as! [Mix]).count > 0 {
                customMixes = context as! [Mix]
            }
        }
        WatchSessionManager.sharedManager.addWatchDataChangedDelegate(delegate: self)
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
        WatchSessionManager.sharedManager.removeWatchDataChangedDelegate(delegate: self)
        super.didDeactivate()
    }
    
    func watchDataDidUpdate(watchData: WatchData) {
        customMixes = watchData.customMixes
        loadTableData()
    }
    
    func loadTableData() {
        tableView.setNumberOfRows( customMixes.count, withRowType: "customRowController")
        for (index, rowModel) in customMixes.enumerated() {
            
            if let customRowController = tableView.rowController(at: index) as? customRowController
            {
                customRowController.mixLabel.setText(rowModel.mixDescription)
                //print("row set \(rowModel.mixDescription)")
            }
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        
    }

}
