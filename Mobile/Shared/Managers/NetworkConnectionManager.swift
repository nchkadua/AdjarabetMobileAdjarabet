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
    
    let reachability = Reachability()!
    
    private init() {
        reachability.whenReachable = { _ in
            print("*** reachable from reachability.whenReachable")
            self.notifyNetworkConnectionEstablish()
        }
        
        reachability.whenUnreachable = { _ in
            print("*** unreachanbe from reachability.whenReachable")
            self.notifyNetworkConnectionLose()
        }
        
//        NotificationCenter.default.addObserver(self, selector: #selector(networkConnectionChanged), name: ReachabilityChangedNotification, object: reachability)
        
    }
    
//    @objc func networkConnectionChanged(note: Notification) {
//        let reachability = note.object as! Reachability
//        if reachability.isReachable {
//            print("*** reachable from networkConnectionChanged")
//        } else {
//            print("*** unreachable from networkConnectionChanged")
//        }
//    }
    
    func startMonitoringConnectivity() {
        do {
            try reachability.startNotifier()
        } catch {}
//        let monitor = NWPathMonitor()
//        monitor.pathUpdateHandler = { path in
//            if path.status == .satisfied {
//                self.notifyNetworkConnectionEstablish()
//            } else {
//                self.notifyNetworkConnectionLose()
//            }
//        }
//
//        let q = DispatchQueue(label: Constants.title)
//        monitor.start(queue: q)
    }
    
    // MARK: - NetworkConnectionObservable
    var observers: [NetworkConnectionObserver] = []
    
    private var currentObserverId: Int = 0
    
    var newObserverId: Int {
        get {
            currentObserverId += 1
            print("NetworkConnectionManager: newId is \(currentObserverId)")
            return currentObserverId
        }
    }
    
    func addObserver(_ observer: NetworkConnectionObserver) {
        guard !observers.contains(where: {$0.networkConnectionObserverId == observer.networkConnectionObserverId}) else { return }
        print("NetworkConnectionManager: observer with id: \(observer.networkConnectionObserverId) added")
        observers.append(observer)
    }
    
    func removeObserver(_ observer: NetworkConnectionObserver) {
        guard let index = observers.firstIndex(where: { $0.networkConnectionObserverId == observer.networkConnectionObserverId }) else { return }
        observers.remove(at: index)
    }
    
    func notifyNetworkConnectionEstablish() {
        print("*** Manager.notifyNetworkConnectionEstablish")
        observers.forEach({ $0.networkConnectionEstablished()})
    }
    
    func notifyNetworkConnectionLose() {
        print("*** Manager.notifyNetworkConnectionLose")
        observers.forEach({ $0.networkConnectionLost()})
    }
    
    deinit {
        observers.removeAll()
    }
}

extension NetworkConnectionManager {
    struct Constants {
        static let title = "NetworkManager"
    }
}
