//
//  InterfaceController.swift
//  102BarWKExt Extension
//
//  Created by Justin Busse on 23.04.18.
//  Copyright © 2018 102 Bier. All rights reserved.
//
import WatchKit
import Foundation
import CoreData

class InterfaceController: WKInterfaceController {
    
    var data = watchModel()
    
    override init()
    {
        super.init()
    }

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
        if segueIdentifier == "default"
        {
            return data.defaultDrinks
        }
        if segueIdentifier == "custom"
        {
            return data.customDrinks
        }
        else
        {
            return nil
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    

}
