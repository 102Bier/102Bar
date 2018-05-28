//
//  WatchSessionManager.swift
//  102BarWKExt Extension
//
//  Created by Justin Busse on 07.05.18.
//  Copyright © 2018 102 Bier. All rights reserved.
//
import WatchConnectivity
class WatchSessionManager: NSObject, WCSessionDelegate {
    
    public static let sharedManager = WatchSessionManager()
    private override init() {
        super.init()
    }
    
    private let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    private var watchDataChangedDelegates = [WatchDataChangedDelegate]()
    var customMixes = [Mix]()
    var defaultMixes = [Mix]()
    
    func startSession() {
        session?.delegate = self
        session?.activate()
    }
    
//    var customOrDefault : CustomOrDefault = ._none
    
//    public enum CustomOrDefault {
//        case _custom
//        case _default
//        case _none
//    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        
        /*var mixes = [Mix]()
        if let defaultMix = applicationContext["defaultMix"] as? Array<String>
        {
            mixes.append(Mix(mix: defaultMix[0], mixDescription: defaultMix[1]))
        }
        if let defaultIngredients = applicationContext["defaultIngredients"] as? Array<Array<String>>
        {
            for i in 0..<defaultIngredients.count
            {
                mixes.first(where: {$0.mix == defaultIngredients[i][0]})?.ingredients[i].drinkDescription = defaultIngredients[i][1]
                mixes.first(where: {$0.mix == defaultIngredients[i][0]})?.ingredients[i].percentage = Int(defaultIngredients[i][2])!
            }
        }
        for i in 0..<mixes.count {
            print("\(mixes[i].mixDescription)")
            print("\(mixes[i].mix)")
            if let _ = mixes[i].ingredients
            {
                for j in 0..<mixes[i].ingredients.count
                {
                    print("\(mixes[i].ingredients[j].drinkDescription)")
                    print("\(mixes[i].ingredients[j].percentage)")
                }
            }
        }
        print("\n")*/
        
        DispatchQueue.main.async() { [weak self] in
            self?.watchDataChangedDelegates.forEach { $0.watchDataDidUpdate(watchData: WatchData(data: applicationContext as [String : AnyObject]))}
        }
        
        
    }
    
    /*func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
        /*DispatchQueue.main.async() { [weak self] in
            self?.watchDataChangedDelegates.forEach { $0.newWatchData(data: messageData)}
        }*/
        
        switch customOrDefault {
        case ._default:
            watchDataChangedDelegates.first(where: {$0 is defaultDrinkInterfaceController})?.newWatchData(data: messageData)
            customOrDefault = ._none
        case ._custom:
            watchDataChangedDelegates.first(where: {$0 is customDrinksInterfaceController})?.newWatchData(data: messageData)
            customOrDefault = ._none
        default:
            customOrDefault = ._none
        }
        
        print("\(watchDataChangedDelegates[0] is defaultDrinkInterfaceController)")
        print("\(watchDataChangedDelegates[0] is customDrinksInterfaceController)")
        print("\(watchDataChangedDelegates[0] is InterfaceController)")
    }*/
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let alc = message["customAlc"] as? [Bool]
        {
            watchDataChangedDelegates.first(where: {$0 is CustomMixInterfaceController})?.watchDataDidUpdate(watchData: WatchData(data: alc, customOrDefault: "custom"))
        }
        else if let alc = message["defaultAlc"] as? [Bool]
        {
             watchDataChangedDelegates.first(where: {$0 is DefaultMixInterfaceController})?.watchDataDidUpdate(watchData: WatchData(data: alc, customOrDefault: "default"))
        }
        else if let percentage = message["percentage"] as? [Int]
        {
            watchDataChangedDelegates.first(where: {$0 is IngredientsInterfaceController})?.watchDataDidUpdate(watchData: WatchData(data: percentage))
        }
        else if let orderStatus = message["orderStatus"] as? String
        {
            DispatchQueue.main.async() { [weak self] in
                    self?.watchDataChangedDelegates.forEach { $0.gotOrderResponse(response: orderStatus)}
                }
            }
        }
    
    public func addWatchDataChangedDelegate<T>(delegate: T) where T: WatchDataChangedDelegate, T: Equatable {
        watchDataChangedDelegates.append(delegate)
    }
    
    public func removeWatchDataChangedDelegate<T>(delegate: T) where T: WatchDataChangedDelegate, T: Equatable {
        for (index, indexDelegate) in watchDataChangedDelegates.enumerated() {
            if let indexDelegate = indexDelegate as? T, indexDelegate == delegate {
                watchDataChangedDelegates.remove(at: index)
                break
            }
        }
    }
    
    public func request(what: String, who : String) {
        //request alc label, percentage and mixes from iPhone
        session?.sendMessage([what:who],
                             replyHandler: nil,
                             errorHandler:  { error in
                                              print(error.localizedDescription)
                                            }
                            )
    }
    
    public func getPercentage(for mix: String)
    {
        //Deserilizing the percentages doens't work quite well, thats why there is a back up function for it
        session?.sendMessage(["percentage": mix], replyHandler: nil, errorHandler: { error in print(error.localizedDescription)})
    }
}

//protocol to update data sent by the iPhone at any time
protocol WatchDataChangedDelegate {
    func watchDataDidUpdate(watchData: WatchData)
    func gotOrderResponse(response : String)
}
