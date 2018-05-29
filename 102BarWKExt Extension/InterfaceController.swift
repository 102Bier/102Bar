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

class InterfaceController: WKInterfaceController, WatchDataChangedDelegate {
    
    func gotOrderResponse(response: String) {
    }

    var defaultMixes = [Mix]()
    var customMixes = [Mix]()
    
    func watchDataDidUpdate(watchData: WatchData) {
        if(watchData.defaultMixes.count > 0)
        {
            defaultMixes = watchData.defaultMixes
        }
        if watchData.customMixes.count > 0
        {
            customMixes = watchData.customMixes
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        WatchSessionManager.sharedManager.addWatchDataChangedDelegate(delegate: self)
        if defaultMixes.count == 0
        {
            WatchSessionManager.sharedManager.request(what: "mixes", who: "default")
        }
        if defaultMixes.count == 0
        {
            //say user we don't have any default mixes right now
        }
        if customMixes.count == 0
        {
            WatchSessionManager.sharedManager.request(what: "mixes", who: "custom")
        }
        if customMixes.count == 0
        {
            //say user he hasn't any customMixes
        }
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    
    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
        //hand mixes to next interface controller
        if segueIdentifier == "default"
        {
            if defaultMixes.count > 0
            {
                return defaultMixes
            }
        }
        if segueIdentifier == "custom"
        {
            if customMixes.count > 0
            {
                return customMixes
            }
        }
        return nil
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    

}
