//
//  InterfaceController.swift
//  102BarWKExt Extension
//
//  Created by Justin Busse on 23.04.18.
//  Copyright © 2018 102 Bier. All rights reserved.
//
import WatchKit
import Foundation
import WatchConnectivity
import CoreData

class InterfaceController: WKInterfaceController, WCSessionDelegate{
    
    @IBOutlet var testLabel1: WKInterfaceButton!
    
    @IBOutlet var testLabel2: WKInterfaceButton!
    var session : WCSession
    
    override init()
    {
        session = WCSession.default
        super.init()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        NSKeyedUnarchiver.setClass(Mix.self, forClassName: "Mix")
        NSKeyedUnarchiver.setClass(Drink.self, forClassName: "Drink")
        NSKeyedUnarchiver.setClass(DrinkType.self, forClassName: "DrinkType")
        NSKeyedUnarchiver.setClass(DrinkGroup.self, forClassName: "DrinkGroup")
        let aD = NSKeyedUnarchiver.unarchiveObject(with: messageData) as? [Mix]
        print(aD?[0].mixDescription)
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        //let test = message["aD"] as! Mix
        //print(test.mixDescription)
        if let test = message["test1"]
        {
            testLabel1.setTitle(test as? String)
        }
        if let test = message["test2"]
        {
            testLabel2.setTitle(test as? String)
        }
        if let aD = message["aD"] {
          print((aD as! Mix).mixDescription)
        }
       
    }
    

    override func awake(withContext context: Any?) {
        
        
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        session.delegate = self
        session.activate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    

}
