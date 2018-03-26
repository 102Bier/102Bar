//
//  AddDrinkController.swift
//  102Bar
//
//  Created by Justin Busse on 20.03.18.
//  Copyright © 2018 102 Bier. All rights reserved.
//

import UIKit
class AddDrinkController : UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    @IBOutlet weak var percentigeInput2: UITextField!
    @IBOutlet weak var percentigeInput: UITextField!
    @IBOutlet weak var percentigeInput3: UITextField!
    
    @IBOutlet var percenteges: [UITextField]!
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        for i in 0...ingredArray[0].sectionPercentage.count-1 {
            ingredArray[0].sectionPercentage[i] = percenteges[i].text!
        }
        percenteges.forEach { p in p.resignFirstResponder() }
    }
    
    @IBOutlet weak var tableView: UITableView!

    var cellHeight : CGFloat = 0
    var cons : CGFloat = 15
    
    struct SectionAndObjects {
        var sectionName : String!
        var sectionObjects : [String]!
        var sectionPercentage : [String]!
    }
    
    var ingredArray = [SectionAndObjects]()
    let helpText = "Drag here to add stuff"
    let noMoreIngredientsText = "You greedy little bitch"
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cellHeight = tableView.visibleCells[0].bounds.height //returns height of first cell, represantative for all cells, just available when tableView (sub view) loaded
        cons = cellHeight - percenteges[0].frame.height //constant for contraints for accurate y-spacing of pI's
        updateViewConstraints()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let availableIngredients = ["Wodka", "Gletscherwasser", "Wiskey", "Jägermeister", "Cola", "Fanta", "Organgensaft", "Red Bull"]
        let selectedIngredients : [String] = [helpText]
        
        tableView.setEditing(true, animated: true)
        ingredArray = [SectionAndObjects(sectionName: "Selected ingredients", sectionObjects: selectedIngredients, sectionPercentage : [String]()), SectionAndObjects(sectionName: "Available ingredients", sectionObjects: availableIngredients, sectionPercentage : [String]())]
        
        if(!ingredArray[0].sectionPercentage.isEmpty)
        {
            for i in 0...ingredArray[0].sectionPercentage.count-1 {
                percenteges[i].text = ingredArray[0].sectionPercentage[i]
            }
        }
    }
    
    override func updateViewConstraints() {
        
        super.updateViewConstraints()
        let offset = percenteges[0].constraints[1].constant//gets constant of top-constraint of textfield above pI2
        for i in 1...7 {
            percenteges[i].translatesAutoresizingMaskIntoConstraints = false
            percenteges[i].topAnchor.constraint(equalTo: percenteges[i-1].topAnchor, constant: offset + cons).isActive = true //accurate y-spacing
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredArray[section].sectionObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Custom drinks", for: indexPath)
        
        cell.textLabel?.text = ingredArray[indexPath.section].sectionObjects[indexPath.row]
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ingredArray.count;
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.none
    }
    
    func updateTableviewTextfieldVisibility(_ sourceIndexPath: IndexPath, destinationIndexPath: IndexPath) {
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
    }
        
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let sourceIngredient = ingredArray[sourceIndexPath.section].sectionObjects[sourceIndexPath.row]
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
            ingredArray[sourceIndexPath.section].sectionPercentage.swapAt(sourceIndexPath.row, destinationIndexPath.row) //swap texts
        }
        
        if ingredArray[destinationIndexPath.section].sectionName == "Selected ingredients" { /*something was dragged to 1st section*/
            
            ingredArray[destinationIndexPath.section].sectionPercentage.insert("0", at: destinationIndexPath.row)
            
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
            ingredArray[sourceIndexPath.section].sectionPercentage.remove(at: sourceIndexPath.row) //remove text from 1st section
        }
        
        if((ingredArray[sourceIndexPath.section].sectionName == "Selected ingredients") &&     /*something was dragged from 1st section*/ (ingredArray[sourceIndexPath.section].sectionObjects.isEmpty)) /*and 1st section is now empty*/
        {
            ingredArray[sourceIndexPath.section].sectionObjects.append(helpText) //show help text
        }
        
        if((ingredArray[sourceIndexPath.section].sectionName == "Available ingredients") && /*something was dragged from 2nd section*/
            ingredArray[sourceIndexPath.section].sectionObjects.isEmpty) /*and 2ND section is now empty*/
        {
            ingredArray[sourceIndexPath.section].sectionObjects.append(noMoreIngredientsText)
        }
        
        /*update texts, reconsider position of code*/
        for i in 0...ingredArray[0].sectionPercentage.count-1 {
            percenteges[i].text = ingredArray[0].sectionPercentage[i]
        }
        
        updateTableviewTextfieldVisibility(sourceIndexPath, destinationIndexPath: destinationIndexPath)
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ingredArray[section].sectionName
    }
    
    @IBAction func CancelTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SaveTapped(_ sender: UIBarButtonItem) {
        
    }
}
