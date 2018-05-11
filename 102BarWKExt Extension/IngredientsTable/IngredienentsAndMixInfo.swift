//
//  IngredienentsAndMixName.swift
//  102BarWKExt Extension
//
//  Created by Justin Busse on 08.05.18.
//  Copyright © 2018 102 Bier. All rights reserved.
//

import Foundation
class IngredientsAndMixInfo
{
    var ingredients : [Drink]
    var mixName : String
    var mixId : String
    
    init(ingredients : [Drink], mixName : String, mixId : String)
    {
        self.ingredients = ingredients
        self.mixName = mixName
        self.mixId = mixId
    }
}
