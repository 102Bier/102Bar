//
//  WatchData.swift
//  102BarWKExt Extension
//
//  Created by Justin Busse on 07.05.18.
//  Copyright © 2018 102 Bier. All rights reserved.
//
import Foundation
class WatchData {
    
    var customMixes : [Mix] = Array()
    var defaultMixes : [Mix] = Array()
    var mixes : [Mix] = Array()
    var customAlc : [Bool] = Array()
    var defaultAlc : [Bool] = Array()
    var percentages : [Int] = Array()
    
    init(data: Data, customOrDefault : String)
    {
        NSKeyedUnarchiver.setClass(Mix.self, forClassName: "Mix")
        NSKeyedUnarchiver.setClass(Drink.self, forClassName: "Drink")
        NSKeyedUnarchiver.setClass(DrinkType.self, forClassName: "DrinkType")
        NSKeyedUnarchiver.setClass(DrinkGroup.self, forClassName: "DrinkGroup")
        
        if let _mixes = (NSKeyedUnarchiver.unarchiveObject(with: data) as? [Mix])
        {
            mixes = _mixes
        }
    }
    
    init(data: [Bool], customOrDefault : String)
    {
        if customOrDefault == "custom"
        {
            customAlc = data
        }
        else if customOrDefault == "default"
        {
            defaultAlc = data
        }
    }
    
    init(data: [Int])
    {
        percentages = data
    }
    
    init(data: [String : AnyObject]) {
        
        NSKeyedUnarchiver.setClass(Mix.self, forClassName: "Mix")
        NSKeyedUnarchiver.setClass(Drink.self, forClassName: "Drink")
        NSKeyedUnarchiver.setClass(DrinkType.self, forClassName: "DrinkType")
        NSKeyedUnarchiver.setClass(DrinkGroup.self, forClassName: "DrinkGroup")
        
        if let _custom = data["custom"] as? Data
        {
            if let _mixes = (NSKeyedUnarchiver.unarchiveObject(with: _custom) as? [Mix])
            {
                customMixes = _mixes
            }
        }
        else if let _default = data["default"] as? Data
        {
            if let _mixes = (NSKeyedUnarchiver.unarchiveObject(with: _default) as? [Mix])
            {
                defaultMixes = _mixes
            }
        }
    }
}
