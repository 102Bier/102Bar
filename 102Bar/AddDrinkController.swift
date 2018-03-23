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
    
    @IBOutlet weak var percentigeInput: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    struct SectionAndObjects {
        var sectionName : String!
        var sectionObjects : [String]!
    }
    
    var ingredArray = [SectionAndObjects]()
    let helpText = "Drag here to add stuff"
    let noMoreIngredientsText = "You greedy little bitch"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let availableIngredients = ["Wodka", "Gletscherwasser", "Wiskey", "Jägermeister", "Cola", "Fanta", "Organgensaft", "Red Bull"]
        let selectedIngredients : [String] = [helpText]
        
        tableView.setEditing(true, animated: true)
        ingredArray = [SectionAndObjects(sectionName: "Selected ingredients", sectionObjects: selectedIngredients), SectionAndObjects(sectionName: "Available ingredients", sectionObjects: availableIngredients)]
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
        }
        else if ingredArray[sourceIndexPath.section].sectionObjects[sourceIndexPath.row] != helpText &&
                ingredArray[sourceIndexPath.section].sectionObjects[sourceIndexPath.row] != noMoreIngredientsText
        {
            ingredArray[sourceIndexPath.section].sectionObjects.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        }
        
        if((ingredArray[destinationIndexPath.section].sectionName == "Selected ingredients") &&     /*something was dragged to 1st section*/ (ingredArray[destinationIndexPath.section].sectionObjects.count >= 2) /*array of dest Strings contains 2 Strings or more */ &&
            (ingredArray[destinationIndexPath.section].sectionObjects.contains(helpText))) /*dest section has contains the help text*/
        {
            ingredArray[destinationIndexPath.section].sectionObjects.remove(at:
            ingredArray[destinationIndexPath.section].sectionObjects.index(of:
            helpText)!) //remove help text
        }
        if((ingredArray[sourceIndexPath.section].sectionName == "Selected ingredients") &&     /*something was dragged from 1st section*/ (ingredArray[sourceIndexPath.section].sectionObjects.isEmpty)) /*and 1st section is now empty*/
        {
            ingredArray[sourceIndexPath.section].sectionObjects.append(helpText) //show help text
        }
        
        if((ingredArray[sourceIndexPath.section].sectionName == "Available ingredients") &&
            ingredArray[sourceIndexPath.section].sectionObjects.isEmpty)
        {
            ingredArray[sourceIndexPath.section].sectionObjects.append(noMoreIngredientsText)
        }
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
