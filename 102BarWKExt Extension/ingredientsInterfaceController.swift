//
//  IngredientsInterfaceController.swift
//  102BarWKExt Extension
//
//  Created by Justin Busse on 07.05.18.
//  Copyright © 2018 102 Bier. All rights reserved.
//

import WatchKit
class IngredientsInterfaceController : WKInterfaceController {
    
    var ingredients = [Drink]()
    
    @IBOutlet var tableView: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        if context != nil
        {
            if let contextCheck = context as? IngredientsAndMixName
            {
                ingredients = contextCheck.ingredients
                self.setTitle(contextCheck.mixName)
            }
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
        tableView.setNumberOfRows( ingredients.count, withRowType: "ingredientsRowController")
        for (index, rowModel) in ingredients.enumerated() {
            if let ingredientsRowController = tableView.rowController(at: index) as? IngredientRowController
            {
                ingredientsRowController.ingredientLabel.setText(rowModel.drinkDescription)
                ingredientsRowController.percentageLabel.setText(String(rowModel.percentage))
            }
        }
    }
}


