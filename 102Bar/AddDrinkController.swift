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
    var drinkContent = AddDrinkTableContent()
    
    var cells : [DrinkCell] = []
    @IBOutlet var drinkName: UITextField!
    
    
    func dismissKeyboard(at indexPath: IndexPath) {
        cells[indexPath.row].resignFirstResponder()
    }
    
    func safeCellTextField(at indexPath : IndexPath) {
        drinkContent.ingredArray[(indexPath.section)].sectionPercentage[(indexPath.row)] = cells[indexPath.row].percentageTextField.text!
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let cell = textField.superview?.superview as! DrinkCell
        let indexPath = tableView.indexPath(for: cell)
        safeCellTextField(at: indexPath!)
        print("Cell endet editing: \(String(describing: cell.percentageTextField.text))")
    }
    

    var cellHeight : CGFloat = 0
    var cons : CGFloat = 15
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //cellHeight = tableView.visibleCells[0].bounds.height //returns height of first cell, represantative for all cells, just available when tableView (sub view) loaded
        //cons = cellHeight - percenteges[0].frame.height //constant for contraints for accurate y-spacing of pI's
        //updateViewConstraints()
    }
    
    
    override func viewDidLoad() {
        
        self.tableView.rowHeight = 60;
        self.tableView.setEditing(true, animated: true)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelectionDuringEditing = true;
        cells.forEach({c in c.percentageTextField.isUserInteractionEnabled = true})
        super.viewDidLoad()
    }
    
    /*override func updateViewConstraints() {
        
        super.updateViewConstraints()
        let offset = percenteges[0].constraints[1].constant//gets constant of top-constraint of textfield above pI2
        for i in 1...7 {
            percenteges[i].translatesAutoresizingMaskIntoConstraints = false
            percenteges[i].topAnchor.constraint(equalTo: percenteges[i-1].topAnchor, constant: offset + cons).isActive = true //accurate y-spacing
        }
    }*/

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinkContent.ingredArray[section].sectionObjects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrinkCell", for: indexPath) as! DrinkCell
        
        cell.drinkLabel.text = drinkContent.ingredArray[indexPath.section].sectionObjects[indexPath.row]
        //ingredArray[indexPath.section].sectionObjects[indexPath.row]
        cell.percentageTextField.text = drinkContent.ingredArray[indexPath.section].sectionPercentage[indexPath.row]
        cell.selectionStyle = .none
        cells.append(cell)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismissKeyboard(at: indexPath)
        
        safeCellTextField(at: indexPath)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return drinkContent.ingredArray.count;
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.none
    }
    
    /*func updateTableviewTextfieldVisibility(_ sourceIndexPath: IndexPath, destinationIndexPath: IndexPath) {
        if ingredArray[destinationIndexPath.section].sectionName == "Selected ingredients" { //something was moved to 1st section
            let countVisible = ingredArray[destinationIndexPath.section].sectionObjects.count-1 //indexed number of visible text fields
            for i in 0...countVisible {
                percenteges[i].isHidden = false //making textfields visible
            }
            if ingredArray[sourceIndexPath.section].sectionName == "Available ingredients" { // moved enterely in 1st section
                
                
                //swap textfield texts accordingly
            }
        }
            if ingredArray[destinationIndexPath.section].sectionName == "Available ingredients" { //something was moved to 2st section
             let countHidden = ingredArray[sourceIndexPath.section].sectionObjects.count
                for i in countHidden...percenteges.count-1{
                percenteges[i].isHidden = true
            }
        }
    }*/
        
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        /*let sourceIngredient = ingredArray[sourceIndexPath.section].sectionObjects[sourceIndexPath.row]
        //let destinationIngredient = ingredArray[destinationIndexPath.section].sectionObjects[destinationIndexPath.row]
        
        if !ingredArray[destinationIndexPath.section].sectionObjects.contains(sourceIngredient) &&
            sourceIndexPath.section != destinationIndexPath.section &&
            ingredArray[sourceIndexPath.section].sectionObjects[sourceIndexPath.row] != helpText &&
            ingredArray[sourceIndexPath.section].sectionObjects[sourceIndexPath.row] != noMoreIngredientsText
            //if destionation cell doesn't already contain it, and different sections are involved and no message text is selected --> adding
        {
            ingredArray[destinationIndexPath.section].sectionObjects.insert(ingredArray[sourceIndexPath.section].sectionObjects[sourceIndexPath.row], at: destinationIndexPath.row)
            ingredArray[sourceIndexPath.section].sectionObjects.remove(at: sourceIndexPath.row)
            
            //ingredArray[destinationIndexPath.section].sectionPercentage.insert("0", at: destinationIndexPath.row)
        }
        else if ingredArray[sourceIndexPath.section].sectionObjects[sourceIndexPath.row] != helpText &&
                ingredArray[sourceIndexPath.section].sectionObjects[sourceIndexPath.row] != noMoreIngredientsText
        {
            ingredArray[sourceIndexPath.section].sectionObjects.swapAt(sourceIndexPath.row, destinationIndexPath.row)
            /*buggy when swapping in 2nd section*/
            //ingredArray[sourceIndexPath.section].sectionPercentage.swapAt(sourceIndexPath.row, destinationIndexPath.row) //swap texts
        }
        
        if ingredArray[destinationIndexPath.section].sectionName == "Selected ingredients" { /*something was dragged to 1st section*/
            
            if(destinationIndexPath.row != sourceIndexPath.row) {
                //ingredArray[destinationIndexPath.section].sectionPercentage.insert("0", at: destinationIndexPath.row)
                //print("added \(ingredArray[destinationIndexPath.section].sectionPercentage[destinationIndexPath.row]) @ row \(destinationIndexPath.row)")
            }
            
            if( ingredArray[destinationIndexPath.section].sectionObjects.count >= 2) &&/*array of dest Strings contains 2 Strings or more */
                (ingredArray[destinationIndexPath.section].sectionObjects.contains(helpText)) /*dest section contains the help text*/
            {
                ingredArray[destinationIndexPath.section].sectionObjects.remove(at:
                    ingredArray[destinationIndexPath.section].sectionObjects.index(of:
                        helpText)!) //remove help text
            }
        }
        
        if ingredArray[destinationIndexPath.section].sectionName == "Available ingredients" //something was dragged to 2nd section
        {
            //ingredArray[sourceIndexPath.section].sectionPercentage.remove(at: sourceIndexPath.row) //remove text from 1st section
            //print("removed \(ingredArray[sourceIndexPath.section].sectionPercentage[sourceIndexPath.row]) @ row \(sourceIndexPath.row)")
        }
        
        if((ingredArray[sourceIndexPath.section].sectionName == "Selected ingredients") &&     /*something was dragged from 1st section*/ (ingredArray[sourceIndexPath.section].sectionObjects.isEmpty)) /*and 1st section is now empty*/
        {
            ingredArray[sourceIndexPath.section].sectionObjects.append(helpText) //show help text
        }
        
        if((ingredArray[sourceIndexPath.section].sectionName == "Available ingredients") && /*something was dragged from 2nd section*/
            ingredArray[sourceIndexPath.section].sectionObjects.isEmpty) /*and 2nd section is now empty*/
        {
            ingredArray[sourceIndexPath.section].sectionObjects.append(noMoreIngredientsText)
        }
        */
        if sourceIndexPath.section == 0 //top
        {
            if destinationIndexPath.section == 0 //top
            {
                drinkContent.ingredArray[sourceIndexPath.section].sectionPercentage.swapAt(sourceIndexPath.row, destinationIndexPath.row)
                drinkContent.ingredArray[sourceIndexPath.section].sectionObjects.swapAt(sourceIndexPath.row, destinationIndexPath.row)
                
                //swap
            }
            else if destinationIndexPath.section == 1 //bottom
            {
                drinkContent.ingredArray[sourceIndexPath.section].sectionPercentage.remove(at: sourceIndexPath.row)
                drinkContent.ingredArray[sourceIndexPath.section].sectionObjects.remove(at: sourceIndexPath.row)
                //remove
            }
        }
        if sourceIndexPath.section == 1 //bottom
        {
            if destinationIndexPath.section == 0 //top
            {
                drinkContent.ingredArray[destinationIndexPath.section].sectionPercentage.insert("0", at: destinationIndexPath.row)
                drinkContent.ingredArray[destinationIndexPath.section].sectionObjects.insert(drinkContent.ingredArray[sourceIndexPath.section].sectionObjects[sourceIndexPath.row], at: destinationIndexPath.row)
                //insert
            }
            else //bottom
            {
                //nothing
            }
        }
        //safeCellTextField(at: sourceIndexPath)
        print("\(drinkContent.ingredArray[0].sectionObjects)")
        print("\(drinkContent.ingredArray[0].sectionPercentage)")
    }
        
        
        
        /* update texts, reconsider position of code
        if(!ingredArray[0].sectionPercentage.isEmpty)
        {
            for i in 0...ingredArray[0].sectionPercentage.count-1 {
                percenteges[i].text = ingredArray[0].sectionPercentage[i]
            }
        }
        
        updateTableviewTextfieldVisibility(sourceIndexPath, destinationIndexPath: destinationIndexPath)
        
        tableView.reloadData()
    }*/
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return drinkContent.ingredArray[section].sectionName
    }
    
    @IBAction func CancelTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SaveTapped(_ sender: UIBarButtonItem) {
        
    }
}
