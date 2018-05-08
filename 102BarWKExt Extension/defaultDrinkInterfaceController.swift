//
//  defaultDrinkInterfaceController.swift
//  102BarWKExt Extension
//
//  Created by Justin Busse on 23.04.18.
//  Copyright © 2018 102 Bier. All rights reserved.
//

import WatchKit
class defaultDrinkInterfaceController: WKInterfaceController, WatchDataChangedDelegate {
    
    func newWatchData(data: Data) {
        
        NSKeyedUnarchiver.setClass(Mix.self, forClassName: "Mix")
        NSKeyedUnarchiver.setClass(Drink.self, forClassName: "Drink")
        NSKeyedUnarchiver.setClass(DrinkType.self, forClassName: "DrinkType")
        NSKeyedUnarchiver.setClass(DrinkGroup.self, forClassName: "DrinkGroup")
        
        if let mixes = (NSKeyedUnarchiver.unarchiveObject(with: data) as? [Mix])
        {
            defaultMixes = mixes
        }
    }
    
    
    @IBOutlet var tableView: WKInterfaceTable!
    
    var defaultMixes : [Mix] = Array()

    override func awake(withContext context: Any?) {
        if context != nil
        {
            if (context as! [Mix]).count > 0
            {
                defaultMixes = context as! [Mix]
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
        if watchData.defaultMixes.count > 0
        {
            defaultMixes = watchData.defaultMixes
            loadTableData()
        }
    }
    
    func loadTableData() {
        tableView.setNumberOfRows( defaultMixes.count, withRowType: "defaultRowController")
        for (index, rowModel) in defaultMixes.enumerated() {
            
            if let defaultRowController = tableView.rowController(at: index) as? defaultRowController
            {
                defaultRowController.mixLabel.setText(rowModel.mixDescription)
                //print("row set \(rowModel.mixDescription)")
            }
        }
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        if segueIdentifier == "defaultRow"
        {
            let context : IngredientsAndMixName = IngredientsAndMixName(ingredients: defaultMixes[rowIndex].ingredients, mixName: defaultMixes[rowIndex].mixDescription)
            return context
        }
        return nil
    }
}
