//
//  CustomDrinkInterfaceController.swift
//  102BarWKExt Extension
//
//  Created by Justin Busse on 11.05.18.
//  Copyright © 2018 102 Bier. All rights reserved.
//

import WatchKit
class CustomMixInterfaceController: WKInterfaceController, WatchDataChangedDelegate {
    
    func newWatchData(data: Data) {
        
        NSKeyedUnarchiver.setClass(Mix.self, forClassName: "Mix")
        NSKeyedUnarchiver.setClass(Drink.self, forClassName: "Drink")
        NSKeyedUnarchiver.setClass(DrinkType.self, forClassName: "DrinkType")
        NSKeyedUnarchiver.setClass(DrinkGroup.self, forClassName: "DrinkGroup")
        
        if let mixes = (NSKeyedUnarchiver.unarchiveObject(with: data) as? [Mix])
        {
            customMixes = mixes
        }
    }
    
    func gotOrderResponse(response: String) {
        let action = WKAlertAction(title: "OK", style: .default) {}
        presentAlert(withTitle: "Order Response", message: response, preferredStyle: .actionSheet, actions: [action])
    }
    
    @IBOutlet var tableView: WKInterfaceTable!
    
    var customMixes : [Mix] = Array()
    var alc : [Bool] = Array()
    var percentages : [Int] = Array()
    
    override func awake(withContext context: Any?) {
        if context != nil
        {
            if (context as! [Mix]).count > 0
            {
                customMixes = context as! [Mix]
            }
        }
        WatchSessionManager.sharedManager.addWatchDataChangedDelegate(delegate: self)
        WatchSessionManager.sharedManager.request(what: "alcoholic", who : "custom")
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
            loadTableData()
        }
        if watchData.customAlc.count == customMixes.count {
            alc = watchData.customAlc
            loadAlcLabel()
        }
    }
    
    func loadTableData() {
        tableView.setNumberOfRows( customMixes.count, withRowType: "customRowController")
        for (index, rowModel) in customMixes.enumerated() {
            
            if let customRowController = tableView.rowController(at: index) as? CustomRowController
            {
              customRowController.mixLabel.setText(rowModel.mixDescription)
                
                if alc.count == customMixes.count
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
            }
        }
    }
    
    func loadAlcLabel()
    {
        for (index, alcoholic) in alc.enumerated() {
            
            if let customRowController = tableView.rowController(at: index) as? CustomRowController
            {
                if alc.count == customMixes.count
                {
                    if alcoholic == true
                    {
                        customRowController.alcLabel.setText("alc")
                    }
                    else
                    {
                        customRowController.alcLabel.setText("no alc")
                    }
                }
            }
        }
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        if segueIdentifier == "customRow"
        {
            let context : IngredientsAndMixInfo = IngredientsAndMixInfo(ingredients: customMixes[rowIndex].ingredients, mixName: customMixes[rowIndex].mixDescription, mixId : customMixes[rowIndex].mix)
            return context
        }
        return nil
    }
}
