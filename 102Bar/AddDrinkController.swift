//
//  AddDrinkController.swift
//  102Bar
//
//  Created by Justin Busse on 20.03.18.
//  Copyright © 2018 102 Bier. All rights reserved.
//

import UIKit
class AddDrinkController : UITableViewController, UITextFieldDelegate
{
    var drinkContent : AddDrinkTableContent = AddDrinkTableContent()
    var customDrinkModel : CustomDrinkModel = CustomDrinkModel()
    
    @IBOutlet var drinkName: UITextField!
    @IBOutlet var totalPercentage: UILabel!
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer)
    {
            // Delete selected Cell
            let point = sender.location(in: self.tableView)
            let indexPath = self.tableView?.indexPathForRow(at: point)
            //        let cell = self.collectionView?.cellForItem(at: indexPath!)
            if indexPath != nil
            {
                let cell  = tableView.cellForRow(at: indexPath!) as! DrinkCell
                print("selectedCell : \(cell.drinkLabel.text ?? ("none"))")
                dismissKeyboard()
            }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func safeCellTextField(at indexPath : IndexPath, in cell : DrinkCell) {
        if var percentage = cell.percentageTextField.text
        {
            if(percentage.contains(","))
            {
                let index = percentage.index(of: ",")
                percentage.remove(at: index!)
                percentage.insert(".", at: index!)
            }
            drinkContent.ingredArray[indexPath.section].sectionPercentage[indexPath.row] = percentage
        }
        else
        {
            drinkContent.ingredArray[indexPath.section].sectionPercentage[indexPath.row] = "0"
        }
        
        print("safed content of \(cell.drinkLabel.text ?? "none") (\(cell.percentageTextField.text ?? "N/A")%)")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var percentageSum: Float = 0
        let topSectionPercCount = drinkContent.ingredArray[0].sectionPercentage.count
        if topSectionPercCount > 0
        {
            let cells = tableView.visibleCells
            var currentRow : Int?
            for i in 0..<cells.count
            {
                if (cells[i] as! DrinkCell).percentageTextField.isFirstResponder == true
                {
                    currentRow = i
                    break
                }
            }
            for i in 0..<topSectionPercCount
            {
                percentageSum += Float(drinkContent.ingredArray[0].sectionPercentage[i])!
            }
            
            percentageSum -= Float(drinkContent.ingredArray[0].sectionPercentage[currentRow!])!
        let currentLocale = Locale.current
        let decimalSeperator = currentLocale.decimalSeparator ?? "."
        let existingTextHasDecimalSeperator = textField.text?.range(of: decimalSeperator) //check if existing text has a (or other region specific decimal seperator)
        let replacementTextHasDecimalSeperator = string.range(of: decimalSeperator) //check if new text has a "." (or other region specific decimal seperator)
        let allowedCharacters = CharacterSet.decimalDigits
        var validCharacterCount : Int = 0
        if let rangeOfCharactersAllowed = string.rangeOfCharacter(from: allowedCharacters) { // if replacementText contains just valid characters
            validCharacterCount = string.characters.distance(from: rangeOfCharactersAllowed.lowerBound, to: rangeOfCharactersAllowed.upperBound)
        }
            
        else if string != decimalSeperator && string.count > 0{
            return false
        }
        
        if validCharacterCount != string.characters.count && string != decimalSeperator {
            return false
        }
            
        else if (existingTextHasDecimalSeperator != nil && replacementTextHasDecimalSeperator != nil) {
            return false
        }

        var newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        if newString.last == decimalSeperator.first
        {
            newString.removeLast()
            newString.append(".0")
        }
        if NSString(string: newString).floatValue > 100
        {
            return false
        }
        
        
            
            
            //percentageSum - was vorher drin stand im textfeld + current im textfeld
            if var oldString = textField.text {
                if oldString == ""
                {
                    oldString = "0"
                }
                if oldString.last == decimalSeperator.first
                {
                    oldString.removeLast()
                    oldString.append(".0")
                }
                if(oldString.contains(","))
                {
                    let index = oldString.index(of: ",")
                    oldString.remove(at: index!)
                    oldString.insert(".", at: index!)
                }
                if(newString.contains(","))
                {
                    let index = newString.index(of: ",")
                    newString.remove(at: index!)
                    newString.insert(".", at: index!)
                }
                if(newString == "")
                {
                    newString = "0"
                }
                percentageSum += Float(newString)!
                
                /*var difference : Float = 0
                if Float(newString)! > Float(oldString)!
                {
                    difference = Float(newString)! - Float(oldString)!
                    percentageSum -= difference
                }
                else
                {
                    difference = Float(oldString)! - Float(newString)!
                    percentageSum -= difference
                }*/
                
                if Float(newString)! <= Float(oldString)! || percentageSum <= 100 || string.count == 0
                {
                    self.totalPercentage.text = String(percentageSum)
                    return true
                }
            }
            else {
                return false
            }
        }
        else
        {
            return true
        }
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let cell = textField.superview?.superview as! DrinkCell
        let indexPath = tableView.indexPath(for: cell)
        let currentLocale = Locale.current
        let decimalSeperator = currentLocale.decimalSeparator ?? "."
        var text = textField.text
        if textField.text == ""
        {
            textField.text = "0"
            drinkContent.ingredArray[0].sectionPercentage[(indexPath?.row)!] = "0"
        }
        if textField.text?.last == decimalSeperator.last
        {
            text?.removeLast()
            text?.append(".0")
        }
        var comma = false
        if(text?.contains(","))!
        {
            let index = text?.index(of: ",")
            text?.remove(at: index!)
            text?.insert(".", at: index!)
            comma = true
        }
        let number = NSString(string: text!).floatValue
        var formattedNumber = "0"
        if number.truncatingRemainder(dividingBy: 1) == 0
        {
            formattedNumber = String(format: "%.0f", number)
        }
        else if (number * 10).truncatingRemainder(dividingBy: 1) == 0
        {
            formattedNumber = String(format: "%.1f", number)
        }
        else
        {
            formattedNumber = String(format: "%.2f", number)
        }
        if(formattedNumber.contains("."))
        {
            let index = formattedNumber.index(of: ".")
            formattedNumber.remove(at: index!)
            formattedNumber.insert(",", at: index!)
            comma = true
        }
        textField.text = String(formattedNumber) //009.7 -> 9.7
        var percentageSum: Float = 0
        let topSectionPercCount = drinkContent.ingredArray[0].sectionPercentage.count
        for i in 0..<topSectionPercCount
        {
            percentageSum += Float(drinkContent.ingredArray[0].sectionPercentage[i])!
        }
        percentageSum -= (Float(drinkContent.ingredArray[0].sectionPercentage[(indexPath?.row)!])! - Float(number))
       
        if(percentageSum <= 100)
        {
            safeCellTextField(at: indexPath!, in: cell)
        }
        print("Cell endet editing: \(String(describing: cell.percentageTextField.text))")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tableView.rowHeight = 60;
        self.tableView.setEditing(true, animated: true)
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinkContent.ingredArray[section].sectionObjects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrinkCell", for: indexPath) as! DrinkCell
        
        cell.drinkLabel.text = drinkContent.ingredArray[indexPath.section].sectionObjects[indexPath.row]
        if(drinkContent.ingredArray[indexPath.section].sectionPercentage.count > 0)
        {
            cell.percentageTextField.text = drinkContent.ingredArray[indexPath.section].sectionPercentage[indexPath.row]
        }
        cell.selectionStyle = .none
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return drinkContent.ingredArray.count;
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.none
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        if((sourceIndexPath.row != destinationIndexPath.row || sourceIndexPath.section != destinationIndexPath.section)
            && drinkContent.ingredArray[sourceIndexPath.section].sectionObjects[sourceIndexPath.row] != drinkContent.helpText
            && drinkContent.ingredArray[sourceIndexPath.section].sectionObjects[sourceIndexPath.row] != drinkContent.noMoreIngredientsText)
        {
            if(sourceIndexPath.section == destinationIndexPath.section)
            {
                var i = 0
                var j = 0
                if(destinationIndexPath.row < sourceIndexPath.row)
                {
                    i = 0
                    j = 1
                }
                if(destinationIndexPath.row > sourceIndexPath.row)
                {
                    i = 1
                    j = 0
                }
                    drinkContent.ingredArray[sourceIndexPath.section].sectionObjects.insert(drinkContent.ingredArray[sourceIndexPath.section].sectionObjects[sourceIndexPath.row], at: destinationIndexPath.row+i)
                
                    drinkContent.ingredArray[sourceIndexPath.section].sectionObjects.remove(at: sourceIndexPath.row+j)
                    drinkContent.ingredArray[sourceIndexPath.section].sectionPercentage.insert(drinkContent.ingredArray[sourceIndexPath.section].sectionPercentage[sourceIndexPath.row], at: destinationIndexPath.row+i)
                
                    drinkContent.ingredArray[sourceIndexPath.section].sectionPercentage.remove(at: sourceIndexPath.row+j)
            }
            else if sourceIndexPath.section == 0 && destinationIndexPath.section == 1 //top to bottom
            {
            drinkContent.ingredArray[destinationIndexPath.section].sectionPercentage.insert(drinkContent.ingredArray[sourceIndexPath.section].sectionPercentage[sourceIndexPath.row], at: destinationIndexPath.row) //insert % in destination
            
                print("inserted \(drinkContent.ingredArray[sourceIndexPath.section].sectionObjects[sourceIndexPath.row]) at row \(destinationIndexPath.row) in section \(destinationIndexPath.section)")
                drinkContent.ingredArray[destinationIndexPath.section].sectionObjects.insert(drinkContent.ingredArray[sourceIndexPath.section].sectionObjects[sourceIndexPath.row], at: destinationIndexPath.row) //insert obj in destination
            
                drinkContent.ingredArray[sourceIndexPath.section].sectionPercentage.remove(at: sourceIndexPath.row) //remove % in source
            
                drinkContent.ingredArray[sourceIndexPath.section].sectionObjects.remove(at: sourceIndexPath.row) //remove obj in source
                
                if(drinkContent.ingredArray[sourceIndexPath.section].sectionObjects.count == 0)
                {
                    drinkContent.ingredArray[sourceIndexPath.section].sectionObjects.append(drinkContent.helpText)
                    drinkContent.ingredArray[sourceIndexPath.section].sectionPercentage.append("0")
                }
                if (drinkContent.ingredArray[destinationIndexPath.section].sectionObjects.count > 1) &&
                    (drinkContent.ingredArray[destinationIndexPath.section].sectionObjects.contains(drinkContent.noMoreIngredientsText))
                {
                    drinkContent.ingredArray[destinationIndexPath.section].sectionPercentage.remove(at: drinkContent.ingredArray[destinationIndexPath.section].sectionObjects.index(of: drinkContent.noMoreIngredientsText)!)
                    
                    drinkContent.ingredArray[destinationIndexPath.section].sectionObjects.remove(at: drinkContent.ingredArray[destinationIndexPath.section].sectionObjects.index(of: drinkContent.noMoreIngredientsText)!)
                }
                    
            }
            else if sourceIndexPath.section == 1  && destinationIndexPath.section == 0 //bottom to top
            {
                drinkContent.ingredArray[destinationIndexPath.section].sectionPercentage.insert(getDefaultPercentage(), at: destinationIndexPath.row) //insert smart % at destination
                drinkContent.ingredArray[destinationIndexPath.section].sectionObjects.insert(drinkContent.ingredArray[sourceIndexPath.section].sectionObjects[sourceIndexPath.row], at: destinationIndexPath.row) //insert obj at destination
                
                print("inserted \(drinkContent.ingredArray[sourceIndexPath.section].sectionObjects[sourceIndexPath.row]) at row \(destinationIndexPath.row) in section \(destinationIndexPath.section)")
                
                drinkContent.ingredArray[sourceIndexPath.section].sectionPercentage.remove(at: sourceIndexPath.row) //remove % at source
                
                drinkContent.ingredArray[sourceIndexPath.section].sectionObjects.remove(at: sourceIndexPath.row) //remove obj at source
            }
            
            if(drinkContent.ingredArray[destinationIndexPath.section].sectionObjects.count > 1 && drinkContent.ingredArray[destinationIndexPath.section].sectionObjects.contains(drinkContent.helpText)) //if more than one elements is in top section and one of them is the helptext
            {
                drinkContent.ingredArray[destinationIndexPath.section].sectionPercentage.removeLast() //remove help text row percenatge
                
                drinkContent.ingredArray[destinationIndexPath.section].sectionObjects.remove(at: drinkContent.ingredArray[0].sectionObjects.index(of: drinkContent.helpText)!)
                //remove help text
            }
            
            if drinkContent.ingredArray[sourceIndexPath.section].sectionObjects.count == 0
            {
                drinkContent.ingredArray[sourceIndexPath.section].sectionObjects.append(drinkContent.noMoreIngredientsText)
                drinkContent.ingredArray[sourceIndexPath.section].sectionPercentage.append("0")
            }
        }
        
        tableView.reloadData()
        let cell = tableView.cellForRow(at: destinationIndexPath) as! DrinkCell
        safeCellTextField(at: destinationIndexPath, in: cell)
        let visibleCells = tableView.visibleCells
        
        for i in 0..<visibleCells.count
        {
            let cellIndex = tableView.indexPath(for: visibleCells[i])
            let cell = (visibleCells[i] as! DrinkCell)
            if cellIndex?.section == 0
            {
                if(cell.drinkLabel.text == drinkContent.helpText)
                {
                    cell.percentageTextField.isHidden = true;
                }
                else
                {
                     cell.percentageTextField.isHidden = false;
                }
            }
            else
            {
                cell.percentageTextField.isHidden = true;
            }
        }
        
        /*for i in 0..<drinkContent.ingredArray[0].sectionObjects.count
        {
            let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as! DrinkCell
            cell.percentageTextField.isHidden = false
        }*/
        /*for i in 0..<drinkContent.ingredArray[1].sectionObjects.count
        {
            let cell = tableView.cellForRow(at: IndexPath(row: i, section: 1))
            //try((cell as! DrinkCell).percentageTextField.isHidden = true)
        }*/
        
        /*debug*/
        print("\n")
        for i in 0..<drinkContent.ingredArray[0].sectionObjects.count
        {
            print(drinkContent.ingredArray[0].sectionObjects[i], drinkContent.ingredArray[0].sectionPercentage[i])
        }
        print("---------------------")
        for i in 0..<drinkContent.ingredArray[1].sectionObjects.count
        {
            print(drinkContent.ingredArray[1].sectionObjects[i], drinkContent.ingredArray[1].sectionPercentage[i])
        }
        print("\npercentages:")
        for i in 0..<drinkContent.ingredArray[0].sectionPercentage.count
        {
            print("\(i): \(drinkContent.ingredArray[0].sectionPercentage[i])")
        }
        print("---------------------")
        for i in 0..<drinkContent.ingredArray[1].sectionPercentage.count
        {
            print("\(i): \(drinkContent.ingredArray[1].sectionPercentage[i])")
        }
        
    }
    
    func getDefaultPercentage() -> String
    {
        var percentageSum: Float = 0
        var topSectionObjCount = drinkContent.ingredArray[0].sectionObjects.count
        if drinkContent.ingredArray[0].sectionObjects.contains(drinkContent.helpText)
        {
            topSectionObjCount -= 1
        }
        let topSectionPercCount = drinkContent.ingredArray[0].sectionPercentage.count
        for i in 0..<topSectionPercCount
        {
            percentageSum += Float(drinkContent.ingredArray[0].sectionPercentage[i])!
        }
        if(percentageSum == 0)
        {
            self.totalPercentage.text = String(100)
            return String(100)
        }
        let percentage = (100 - percentageSum)
        self.totalPercentage.text = String(percentageSum+percentage)

        return percentage.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", percentage) : String(format: "%.2f", percentage)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return drinkContent.ingredArray[section].sectionName
    }
    
    @IBAction func CancelTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SaveTapped(_ sender: UIBarButtonItem) {
        
        var drinks : [Drink] = Array()
        for i in 0..<drinkContent.ingredArray[0].sectionObjects.count
        {
          //  let drink = Drink(description: drinkContent.ingredArray[0].sectionObjects[i], percentage: Float(drinkContent.ingredArray[0].sectionPercentage[i])!)
          //  drinks.append(drink)
        }
        
        
        //customDrinkModel.addMix(mix: Mix(ingredients: drinks))
    }
}
