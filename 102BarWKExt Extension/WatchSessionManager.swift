//
//  WatchSessionManager.swift
//  102BarWKExt Extension
//
//  Created by Justin Busse on 07.05.18.
//  Copyright © 2018 102 Bier. All rights reserved.
//
import WatchConnectivity
class WatchSessionManager: NSObject, WCSessionDelegate {
    
    // Instantiate the Singleton
    public static let sharedManager = WatchSessionManager()
    private override init() {
        super.init()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
            watchDataChangedDelegates.forEach { $0.watchDataDidUpdate(watchData: WatchData(data: applicationContext as [String : AnyObject]))}
    }
    
    private let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    private var watchDataChangedDelegates = [WatchDataChangedDelegate]()
    var customMixes = [Mix]()
    var defaultMixes = [Mix]()
    
    func startSession() {
        session?.delegate = self
        session?.activate()
    }
    
    /* https://www.natashatherobot.com/watchconnectivity-application-context/ */
    public func addWatchDataChangedDelegate<T>(delegate: T) where T: WatchDataChangedDelegate, T: Equatable {
        watchDataChangedDelegates.append(delegate)
    }
    
    /* https://www.natashatherobot.com/watchconnectivity-application-context/ */
    public func removeWatchDataChangedDelegate<T>(delegate: T) where T: WatchDataChangedDelegate, T: Equatable {
        for (index, indexDelegate) in watchDataChangedDelegates.enumerated() {
            if let indexDelegate = indexDelegate as? T, indexDelegate == delegate {
                watchDataChangedDelegates.remove(at: index)
                break
            }
        }
    }
}

protocol WatchDataChangedDelegate {
    func watchDataDidUpdate(watchData: WatchData)
}

