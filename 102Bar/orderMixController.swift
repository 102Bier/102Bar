//
//  orderMixController.swift
//  102Bar
//
//  Created by Justin Busse on 16.04.18.
//  Copyright © 2018 102 Bier. All rights reserved.
//

import UIKit
class orderMixController : UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
    @IBOutlet var drinkNameLabel: UILabel!
    @IBOutlet var glassSizeSlider: UISlider!
    @IBOutlet var glassSizeField: UITextField!
    @IBOutlet var totalPercentageLabel: UILabel!
    
    
    @IBAction func tableViewTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func glassSizeSliderChanged(_ sender: UISlider) {
       glassSizeField.text = String(Int((480 * sender.value) + 20))
    }
    
    var mixToOrder: Mix = Mix(mix: "", mixDescription: "", ingredients: Array())
    
    override func viewDidLoad() {
        drinkNameLabel.text = mixToOrder.mixDescription
        super.viewDidLoad()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(string.count < 1) {
            return true
        }
        
        let allowedCharacters = CharacterSet.decimalDigits
        var validCharacterCount : Int = 0
        if let rangeOfCharactersAllowed = string.rangeOfCharacter(from: allowedCharacters) { // if replacementText contains just valid characters
            validCharacterCount = string.characters.distance(from: rangeOfCharactersAllowed.lowerBound, to: rangeOfCharactersAllowed.upperBound)
        }
        
        if validCharacterCount != string.characters.count
        {
            return false
        }
    
        var newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        
        if(textField.tag == 0) //glassSize
        {
            if (Int(newString))! > 500 || ((Int(newString))! < 20 && newString.count > 1)
            {
                return false
            }
            else
            {
                return true
            }
        }
        else if(textField.tag == 1) //percentage
        {
            return false
        }
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 //glassSize
        {
            var test = glassSizeSlider.value
            if let text = textField.text
            {
                let value = (Float(text)! / 480) - (20 / 480)
                glassSizeSlider.setValue(value,  animated: true)
                test = glassSizeSlider.value
            }
        }
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
