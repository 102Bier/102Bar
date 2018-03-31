//
//  AddDrinkTableContent.swift
//  102Bar
//
//  Created by Justin Busse on 26.03.18.
//  Copyright © 2018 102 Bier. All rights reserved.
//
import Foundation
class AddDrinkTableContent {
    
    var percentages : [String]
    struct SectionAndObjects {
        var sectionName : String!
        var sectionObjects : [String]!
        var sectionPercentage : [String]!
        var isHidden : Bool
    }
    //test comment 
    var ingredArray = [SectionAndObjects]()
    let helpText = "Drag here to add"
    let noMoreIngredientsText = "You greedy little bitch"
    
    
    init()
    {
        let availableIngredients = ["Captain Morgan", "Gletscherwasser", "Wiskey", "Jägermeister", "Cola", "Fanta", "Organgensaft", "Red Bull"]
        let selectedIngredients : [String] = [helpText]
        percentages = ["0", "0", "0", "0", "0", "0", "0", "0"]
        let initialPercentages : [String] = ["0"]
        
        ingredArray = [SectionAndObjects(sectionName: "Selected ingredients", sectionObjects: selectedIngredients, sectionPercentage : initialPercentages, isHidden: false), SectionAndObjects(sectionName: "Available ingredients", sectionObjects: availableIngredients, sectionPercentage : percentages, isHidden : true)]
    }
}
