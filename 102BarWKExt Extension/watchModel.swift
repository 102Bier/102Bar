//
//  watchModel.swift
//  102BarWKExt Extension
//
//  Created by Justin Busse on 03.05.18.
//  Copyright © 2018 102 Bier. All rights reserved.
//

import Foundation
import WatchConnectivity
class watchModel : NSObject, WCSessionDelegate {
    
    var defaultDrinks : [Mix]
    var customDrinks : [Mix]
    var mixes : [Mix]
    var session : WCSession
    
    override init() {
        defaultDrinks = Array()
        customDrinks = Array()
        mixes = Array()
        session = .default
        super.init()
        session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        NSKeyedUnarchiver.setClass(Mix.self, forClassName: "Mix")
        NSKeyedUnarchiver.setClass(Drink.self, forClassName: "Drink")
        NSKeyedUnarchiver.setClass(DrinkType.self, forClassName: "DrinkType")
        NSKeyedUnarchiver.setClass(DrinkGroup.self, forClassName: "DrinkGroup")
        mixes = (NSKeyedUnarchiver.unarchiveObject(with: messageData) as? [Mix])!
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let cOrD = message["customOrDefault"]
        {
            if (cOrD as! String) == "custom"
            {
                customDrinks = mixes
            }
            else if (cOrD as! String) == "default"
            {
                defaultDrinks = mixes
            }
        }
    }
    
}
