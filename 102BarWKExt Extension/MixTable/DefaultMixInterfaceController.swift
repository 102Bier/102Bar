//
//  defaultDrinkInterfaceController.swift
//  102BarWKExt Extension
//
//  Created by Justin Busse on 23.04.18.
//  Copyright © 2018 102 Bier. All rights reserved.
//

import WatchKit
class DefaultMixInterfaceController: WKInterfaceController, WatchDataChangedDelegate {
    
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
    
    func gotOrderResponse(response: String) {
        let action = WKAlertAction(title: "OK", style: .default) {}
        presentAlert(withTitle: "Order Response", message: response, preferredStyle: .actionSheet, actions: [action])
    }
    
    @IBOutlet var tableView: WKInterfaceTable!
    
    var defaultMixes : [Mix] = Array()
    var alc : [Bool] = Array()
    var percentages : [Int] = Array()

    override func awake(withContext context: Any?) {
        if context != nil
        {
            if (context as! [Mix]).count > 0
            {
                defaultMixes = context as! [Mix]
            }
        }
        WatchSessionManager.sharedManager.addWatchDataChangedDelegate(delegate: self)
        WatchSessionManager.sharedManager.request(what: "alcoholic", who : "default")
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
        if watchData.defaultAlc.count == defaultMixes.count {
            alc = watchData.defaultAlc
            loadAlcLabel()
        }
    }
    
    func loadTableData() {
        tableView.setNumberOfRows( defaultMixes.count, withRowType: "defaultRowController")
        for (index, rowModel) in defaultMixes.enumerated() {
            
            if let defaultRowController = tableView.rowController(at: index) as? DefaultRowController
            {
                defaultRowController.mixLabel.setText(rowModel.mixDescription)
                
                if alc.count == defaultMixes.count
                {
                    if alc[index] == true
                    {
                        defaultRowController.alcLabel.setText("alc")
                    }
                    else
                    {
                        defaultRowController.alcLabel.setText("no alc")
                    }
                }
            }
        }
    }
    
    func loadAlcLabel()
    {
        for (index, alcoholic) in alc.enumerated() {
            
            if let defaultRowController = tableView.rowController(at: index) as? DefaultRowController
            {
                if alc.count == defaultMixes.count
                {
                    if alcoholic == true
                    {
                        defaultRowController.alcLabel.setText("alc")
                    }
                    else
                    {
                        defaultRowController.alcLabel.setText("no alc")
                    }
                }
            }
        }
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        if segueIdentifier == "defaultRow"
        {
            //hand over information to the ingredients-displaying interface controller
            let context : IngredientsAndMixInfo = IngredientsAndMixInfo(ingredients: defaultMixes[rowIndex].ingredients, mixName: defaultMixes[rowIndex].mixDescription, mixId : defaultMixes[rowIndex].mix)
            return context
        }
        return nil
    }
}
