//
//  NetworkManager.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 07.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Network
import Reachability

protocol NetworkConnectionObserver {
    var networkConnectionObserverId: Int { get set }
    func networkConnectionEstablished()
    func networkConnectionLost()
}

protocol NetworkConnectionObservable {
    var observers: [NetworkConnectionObserver] { get set }
    func addObserver(_ observer: NetworkConnectionObserver)
    func removeObserver(_ observer: NetworkConnectionObserver)
    func notifyNetworkConnectionEstablish()
    func notifyNetworkConnectionLose()
}

class NetworkConnectionManager: NetworkConnectionObservable {
    
    static let shared = NetworkConnectionManager()
    
    public var isConnected = false
    
    let reachability = Reachability()!
    
    private init() {
        reachability.whenReachable = { _ in
            self.notifyNetworkConnectionEstablish()
            self.isConnected = true
        }
        
        reachability.whenUnreachable = { _ in
            self.notifyNetworkConnectionLose()
            self.isConnected = false
        }
    }
    
    func startMonitoringConnectivity() {
        do {
            try reachability.startNotifier()
        } catch {
			print("NetworkConnectionManager: Could not start monitoring of the connectivity")
		}
    }
    
	// MARK: - NetworkConnectionObservable
    var observers: [NetworkConnectionObserver] = []
    
    private var currentObserverId: Int = 0
    
    var newObserverId: Int {
        get {
            currentObserverId += 1
            return currentObserverId
        }
    }
    
    func addObserver(_ observer: NetworkConnectionObserver) {
        guard !observers.contains(where: {$0.networkConnectionObserverId == observer.networkConnectionObserverId}) else { return }
        observers.append(observer)
    }
    
    func removeObserver(_ observer: NetworkConnectionObserver) {
        guard let index = observers.firstIndex(where: { $0.networkConnectionObserverId == observer.networkConnectionObserverId }) else { return }
        observers.remove(at: index)
    }
    
    func notifyNetworkConnectionEstablish() {
        observers.forEach({ $0.networkConnectionEstablished()})
    }
    
    func notifyNetworkConnectionLose() {
        observers.forEach({ $0.networkConnectionLost()})
    }
    
    deinit {
        observers.removeAll()
    }
}
