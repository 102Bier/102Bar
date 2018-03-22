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
    
    @IBOutlet weak var tableView: UITableView!
    
    struct SectionAndObjects {
        var sectionName : String!
        var sectionObjects : [String]!
    }
    
    var objectsArray = [SectionAndObjects]()
    
    var availableIngredients = ["Wodka", "Gletscherwasser", "Wiskey", "Jägermeister"]
    var selectedIngredients = ["Drag here to add stuff"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.setEditing(true, animated: true)
        objectsArray = [SectionAndObjects(sectionName: "Selected ingredients", sectionObjects: selectedIngredients), SectionAndObjects(sectionName: "Available ingredients", sectionObjects: availableIngredients)]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectsArray[section].sectionObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Custom drinks", for: indexPath)
        
        cell.textLabel?.text = objectsArray[indexPath.section].sectionObjects[indexPath.row]
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return objectsArray.count;
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.none
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let sourceSection = objectsArray[sourceIndexPath.section]
        var destinationSection = objectsArray[destinationIndexPath.section]
        
        let sourceIngredient = objectsArray[sourceIndexPath.section].sectionObjects[sourceIndexPath.row]
        //let destinationIngredient = objectsArray[destinationIndexPath.section].sectionObjects[destinationIndexPath.row]
        
        if (objectsArray[sourceIndexPath.section].sectionName == "Available ingredients") && (!objectsArray[destinationIndexPath.section].sectionObjects.contains(sourceIngredient))
            //if moving row from av ing to sel ing and sel ing doesn't already contain it
        {
            objectsArray[destinationIndexPath.section].sectionObjects.insert(objectsArray[sourceIndexPath.section].sectionObjects[sourceIndexPath.row], at: destinationIndexPath.row)
        }

        if((objectsArray[destinationIndexPath.section].sectionName == "Selected ingredients") &&     /*something was dragged to 1st section*/ (objectsArray[destinationIndexPath.section].sectionObjects.count >= 2) &&                /*array of dest Strings contains 2 Strings or more */
            (objectsArray[destinationIndexPath.section].sectionObjects.contains("Drag here to add stuff"))) /*dest section has contains the help text*/
        {
            objectsArray[destinationIndexPath.section].sectionObjects.remove(at:
            objectsArray[destinationIndexPath.section].sectionObjects.index(of:
            "Drag here to add stuff")!) //remove help text
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return objectsArray[section].sectionName
    }
    
    @IBAction func CancelTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SaveTapped(_ sender: UIBarButtonItem) {
    }
}
