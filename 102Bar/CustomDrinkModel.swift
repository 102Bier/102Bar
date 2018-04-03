//
//  CustomDrinkModel.swift
//  102Bar
//
//  Created by Justin Busse on 02.04.18.
//  Copyright © 2018 102 Bier. All rights reserved.
//

import Foundation
class CustomDrinkModel {
    
    var customMixes : [Mix] = Array()
    
    func addMix(mix: Mix)
    {
        customMixes.append(mix)
    }
}
