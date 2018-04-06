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

    @IBOutlet var mixNameTextField: UITextField!
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
            drinkContent.ingredArray[indexPath.section].sectionPercentage[indexPath.row] = percentage
        }
        else
        {
            drinkContent.ingredArray[indexPath.section].sectionPercentage[indexPath.row] = "0"
        }
        
        print("safed content of \(cell.drinkLabel.text ?? "none") (\(cell.percentageTextField.text ?? "N/A")%)")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let allowedCharacters = CharacterSet.decimalDigits
        var validCharacterCount : Int = 0
        if let rangeOfCharactersAllowed = string.rangeOfCharacter(from: allowedCharacters) { // if replacementText contains just valid characters
            validCharacterCount = string.characters.distance(from: rangeOfCharactersAllowed.lowerBound, to: rangeOfCharactersAllowed.upperBound)
        }
        
        if validCharacterCount != string.characters.count
        {
            return false
        }
        
        var percentageSum: Int = 0
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
                percentageSum += Int(drinkContent.ingredArray[0].sectionPercentage[i])!
            }
            
            percentageSum -= Int(drinkContent.ingredArray[0].sectionPercentage[currentRow!])!

            var newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
            
            if NSString(string: newString).intValue > 100
            {
                return false
            }
        
            if var oldString = textField.text
            {
                if oldString == ""
                {
                    oldString = "0"
                }
                
                if(newString == "")
                {
                    newString = "0"
                }
                percentageSum += Int(newString)!
                if Int(newString)! <= Int(oldString)! || percentageSum <= 100 || string.count == 0
                {
                    self.totalPercentage.text = String(percentageSum)+"%"
                    return true
                }
            }
            else
            {
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
        if textField.text == ""
        {
            textField.text = "0"
            drinkContent.ingredArray[0].sectionPercentage[(indexPath?.row)!] = "0"
        }
        let number = NSString(string:  textField.text!).intValue
        textField.text = String(number) //009 -> 9
        var percentageSum: Int = 0
        let topSectionPercCount = drinkContent.ingredArray[0].sectionPercentage.count
        for i in 0..<topSectionPercCount
        {
            percentageSum += Int(drinkContent.ingredArray[0].sectionPercentage[i])!
        }
        percentageSum -= (Int(drinkContent.ingredArray[0].sectionPercentage[(indexPath?.row)!])! - Int(number))
       
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
        var removeHelptext = false
        
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
                
                /****Update total percentage label****/
                totalPercentage.text?.removeLast()
                var totalPercentageNumber : Int = Int(totalPercentage.text!)!
                if let tP = totalPercentage.text
                {
                    if let dCiAsP = Int(drinkContent.ingredArray[destinationIndexPath.section].sectionPercentage[destinationIndexPath.row]) {
                        totalPercentageNumber = Int(tP)! - dCiAsP
                    }
                }
                
                totalPercentage.text = String(totalPercentageNumber) + "%"
 
                
                
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
                
                print("inserted \(drinkContent.ingredArray[destinationIndexPath.section].sectionPercentage[destinationIndexPath.row])%")
                drinkContent.ingredArray[destinationIndexPath.section].sectionObjects.insert(drinkContent.ingredArray[sourceIndexPath.section].sectionObjects[sourceIndexPath.row], at: destinationIndexPath.row) //insert obj at destination
                
                print("inserted \(drinkContent.ingredArray[destinationIndexPath.section].sectionObjects[destinationIndexPath.row]) at row \(destinationIndexPath.row) in section \(destinationIndexPath.section) with \(drinkContent.ingredArray[destinationIndexPath.section].sectionPercentage[destinationIndexPath.row]) %")
                
                drinkContent.ingredArray[sourceIndexPath.section].sectionPercentage.remove(at: sourceIndexPath.row) //remove % at source
                
                drinkContent.ingredArray[sourceIndexPath.section].sectionObjects.remove(at: sourceIndexPath.row) //remove obj at source
            }
            
            if(drinkContent.ingredArray[destinationIndexPath.section].sectionObjects.count > 1 && drinkContent.ingredArray[destinationIndexPath.section].sectionObjects.contains(drinkContent.helpText)) //if more than one elements is in top section and one of them is the helptext
            {
                removeHelptext = true
            }
            
            if drinkContent.ingredArray[sourceIndexPath.section].sectionObjects.count == 0
            {
                drinkContent.ingredArray[sourceIndexPath.section].sectionObjects.append(drinkContent.noMoreIngredientsText)
                drinkContent.ingredArray[sourceIndexPath.section].sectionPercentage.append("0")
            }
        }
        let cell = tableView.cellForRow(at: destinationIndexPath) as! DrinkCell
        print("still \(drinkContent.ingredArray[destinationIndexPath.section].sectionPercentage[destinationIndexPath.row])%")
        
        if(removeHelptext) //must be executed after let cell was set
        {
            drinkContent.ingredArray[0].sectionPercentage.remove(at: drinkContent.ingredArray[0].sectionObjects.index(of: drinkContent.helpText)!)
            //remove help text row percenatge
            
            drinkContent.ingredArray[0].sectionObjects.remove(at: drinkContent.ingredArray[0].sectionObjects.index(of: drinkContent.helpText)!)
            //remove help text
        }
        
        tableView.reloadData()
        
        safeCellTextField(at: sourceIndexPath, in: cell)
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
        var percentageSum: Int = 0
        var topSectionObjCount = drinkContent.ingredArray[0].sectionObjects.count
        if drinkContent.ingredArray[0].sectionObjects.contains(drinkContent.helpText)
        {
            topSectionObjCount -= 1
        }
        let topSectionPercCount = drinkContent.ingredArray[0].sectionPercentage.count
        for i in 0..<topSectionPercCount
        {
            percentageSum += Int(drinkContent.ingredArray[0].sectionPercentage[i])!
        }
        if(percentageSum == 0)
        {
            self.totalPercentage.text = String(100)+"%"
            return String(100)
        }
        let percentage = (100 - percentageSum)
        self.totalPercentage.text = String(percentageSum+percentage) + "%"

        return String(percentage)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return drinkContent.ingredArray[section].sectionName
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Save"
        {
            save()
        }
        else
        {
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func save(){
        
        var mixName : String?
        if(mixNameTextField.hasText)
        {
             mixName = mixNameTextField.text
        }
        else
        {
            let alert = UIAlertController(title: "Please name your drink", message: "To save, you must type in a name for your custom drink", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return
        }

        var txtFieldText = totalPercentage.text
        txtFieldText?.removeLast()
        if Int(txtFieldText!)! != 100
        {
            let alert = UIAlertController(title: "Invalid percentage", message: "To save, the total percentage must be 100", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return
        }
        var drinks : [Drink] = Array()
        for i in 0..<drinkContent.ingredArray[0].sectionObjects.count
        {
            let description = drinkContent.ingredArray[0].sectionObjects[i]
            let percentage = Int(drinkContent.ingredArray[0].sectionPercentage[i])!
            if let ai = Service.shared.testI //crashes right now
            {
                let drink = ai.first(where: {$0.drinkDescription == description})
                drink?.addPercentage(percentage: percentage)
                drinks.append(drink!)
            }
            else {
                //error
                return
            }
        }
        Service.shared.customDrinkModel.addMix(mix: Mix(mix: "", mixDescription: mixName!, ingredients: drinks))
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
