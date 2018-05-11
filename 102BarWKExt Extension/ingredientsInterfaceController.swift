//
//  IngredientsInterfaceController.swift
//  102BarWKExt Extension
//
//  Created by Justin Busse on 07.05.18.
//  Copyright © 2018 102 Bier. All rights reserved.
//

import WatchKit
class IngredientsInterfaceController : WKInterfaceController, WatchDataChangedDelegate {
    
    func watchDataDidUpdate(watchData: WatchData) {
        if watchData.percentages.count > 0 {
            self.percentages = watchData.percentages
        }
        loadPercentageLabels()
    }
    
    var ingredients = [Drink]()
    var mixId : String = ""
    var percentages : [Int] = Array()
    
    @IBOutlet var tableView: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        if context != nil
        {
            if let contextCheck = context as? IngredientsAndMixInfo
            {
                ingredients = contextCheck.ingredients
                self.setTitle(contextCheck.mixName)
                mixId = contextCheck.mixId
            }
        }
        WatchSessionManager.sharedManager.addWatchDataChangedDelegate(delegate: self)
        WatchSessionManager.sharedManager.getPercentage(for: mixId)
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
    
    func loadTableData() {
        tableView.setNumberOfRows( ingredients.count, withRowType: "ingredientsRowController")
        for (index, rowModel) in ingredients.enumerated() {
            if let ingredientsRowController = tableView.rowController(at: index) as? IngredientRowController
            {
                ingredientsRowController.ingredientLabel.setText(rowModel.drinkDescription)
                if rowModel.percentage > 0
                {
                    ingredientsRowController.percentageLabel.setText(String(rowModel.percentage)+"%")
                }
                else if percentages.count == ingredients.count
                {
                    ingredientsRowController.percentageLabel.setText(String(percentages[index])+"%")
                }
            }
        }
    }
    
    func loadPercentageLabels() {
        for (index, percentage) in percentages.enumerated() {
            if let ingredientsRowController = tableView.rowController(at: index) as? IngredientRowController
            {
                if percentages.count == ingredients.count
                {
                    ingredientsRowController.percentageLabel.setText(String(percentage)+"%")
                }
            }
        }
    }
}


