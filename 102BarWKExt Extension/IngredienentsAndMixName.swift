//
//  IngredienentsAndMixName.swift
//  102BarWKExt Extension
//
//  Created by Justin Busse on 08.05.18.
//  Copyright © 2018 102 Bier. All rights reserved.
//

import Foundation
class IngredientsAndMixName
{
    var ingredients : [Drink]
    var mixName : String
    
    init(ingredients : [Drink], mixName : String)
    {
        self.ingredients = ingredients
        self.mixName = mixName
    }
}
