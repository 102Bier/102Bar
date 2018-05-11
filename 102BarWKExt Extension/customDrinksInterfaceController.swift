//
//  customDrinksInterfaceController.swift
//  102BarWKExt Extension
//
//  Created by Justin Busse on 23.04.18.
//  Copyright © 2018 102 Bier. All rights reserved.
//

import WatchKit
class customDrinksInterfaceController: WKInterfaceController, WatchDataChangedDelegate{
    
    func newWatchData(data: Data) {
        
    }
    
    
    @IBOutlet var tableView: WKInterfaceTable!
    
    var customMixes : [Mix] = Array()
    var alc : [Bool] = Array()
    
    override func awake(withContext context: Any?) {
        if context != nil
        {
            if (context as! [Mix]).count > 0 {
                customMixes = context as! [Mix]
            }
        }
        WatchSessionManager.sharedManager.addWatchDataChangedDelegate(delegate: self)
        WatchSessionManager.sharedManager.requestAlcoholic(who : "custom")
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
        if watchData.customMixes.count > 0
        {
            customMixes = watchData.customMixes
        }
        if watchData.customAlc.count == customMixes.count {
            alc = watchData.customAlc
        }
        loadTableData()
    }
    
    func loadTableData() {
        tableView.setNumberOfRows( customMixes.count, withRowType: "customRowController")
        for (index, rowModel) in customMixes.enumerated() {
            
            if let customRowController = tableView.rowController(at: index) as? customRowController
            {
                customRowController.mixLabel.setText(rowModel.mixDescription)
                
                if alc.count >= customMixes.count
                {
                    if alc[index] == true
                    {
                        customRowController.alcLabel.setText("alc")
                    }
                    else
                    {
                        customRowController.alcLabel.setText("no alc")
                    }
                }
                //print("row set \(rowModel.mixDescription)")
            }
        }
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        if segueIdentifier == "customRow"
        {
            let context : IngredientsAndMixName = IngredientsAndMixName(ingredients: customMixes[rowIndex].ingredients, mixName: customMixes[rowIndex].mixDescription)
            return context
        }
        return nil
    }
    
    /*override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        let mix = customMixes[rowIndex]
 
    }*/

}
