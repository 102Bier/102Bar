//
//  orderMixController.swift
//  102Bar
//
//  Created by Justin Busse on 16.04.18.
//  Copyright © 2018 102 Bier. All rights reserved.
//

import UIKit
class orderMixController : UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet var drinkNameLabel: UILabel!
    @IBOutlet var glassSizeSlider: UISlider!
    @IBOutlet var glassSizeField: UITextField!
    @IBOutlet var totalPercentageLabel: UILabel!
    
    @IBAction func glassSizeSliderChanged(_ sender: UISlider) {
        
    }
    
    var mixToOrder: Mix = Mix(mix: "", mixDescription: "", ingredients: Array())
    
    override func viewDidLoad() {
        drinkNameLabel.text = mixToOrder.mixDescription
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mixToOrder.ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderIngred") as! DrinkCell
        cell.drinkLabel.text = mixToOrder.ingredients[indexPath.row].drinkDescription
        cell.percentageTextField.text = String( mixToOrder.ingredients[indexPath.row].percentage)
        return cell
    }  
}
