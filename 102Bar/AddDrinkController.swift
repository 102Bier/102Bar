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
    
    @IBOutlet var drinkName: UITextField!
    
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
        drinkContent.ingredArray[indexPath.section].sectionPercentage[indexPath.row] = cell.percentageTextField.text!
        print("safed content of \(cell.drinkLabel.text ?? "none") (\(cell.percentageTextField.text ?? "N/A")%)")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let cell = textField.superview?.superview as! DrinkCell
        let indexPath = tableView.indexPath(for: cell)
        safeCellTextField(at: indexPath!, in: cell)
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
        cell.percentageTextField.text = drinkContent.ingredArray[indexPath.section].sectionPercentage[indexPath.row]
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
                
                
            }
            else if sourceIndexPath.section == 1  && destinationIndexPath.section == 0 //bottom to top
            {
                drinkContent.ingredArray[destinationIndexPath.section].sectionPercentage.insert("0", at: destinationIndexPath.row) //insert % at destination
                drinkContent.ingredArray[destinationIndexPath.section].sectionObjects.insert(drinkContent.ingredArray[sourceIndexPath.section].sectionObjects[sourceIndexPath.row], at: destinationIndexPath.row) //insert obj at destination
                
                print("inserted \(drinkContent.ingredArray[sourceIndexPath.section].sectionObjects[sourceIndexPath.row]) at row \(destinationIndexPath.row) in section \(destinationIndexPath.section)")
                
                drinkContent.ingredArray[sourceIndexPath.section].sectionPercentage.remove(at: sourceIndexPath.row) //remove % at source
                
                drinkContent.ingredArray[sourceIndexPath.section].sectionObjects.remove(at: sourceIndexPath.row) //remove obj at source
            }
            
            if(drinkContent.ingredArray[destinationIndexPath.section].sectionObjects.count > 1 && drinkContent.ingredArray[destinationIndexPath.section].sectionObjects.contains(drinkContent.helpText)) //if more than one elements is in top section and one of them is the helptext
            {
                drinkContent.ingredArray[destinationIndexPath.section].sectionObjects.remove(at: drinkContent.ingredArray[0].sectionObjects.index(of: drinkContent.helpText)!) //remove help text
            }
            
            if drinkContent.ingredArray[sourceIndexPath.section].sectionObjects.count == 0
            {
                drinkContent.ingredArray[sourceIndexPath.section].sectionObjects.append(drinkContent.noMoreIngredientsText)
                drinkContent.ingredArray[sourceIndexPath.section].sectionPercentage.append("0")
            }
        }
        
        tableView.reloadData()
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
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return drinkContent.ingredArray[section].sectionName
    }
    
    @IBAction func CancelTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SaveTapped(_ sender: UIBarButtonItem) {
        
    }
}
