//
//  ODRManager.swift
//  Mobile
//
//  Created by Nika Chkadua on 1/26/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

class ODRManager: NSObject {
    static let shared = ODRManager()
    private static let progressObservingKeyPath = "fractionCompleted"
    var progressObservingContext: UnsafeMutableRawPointer? = nil
    
    public func loadResourcesWithTags(_ tagArray: Array<String>, completion: @escaping ((ODRResult<Bool, NSError>) -> Void)) {
        
        let tags = NSSet(array: tagArray)
        let tagsSet = tags as! Set<String>
        
        Bundle.main.setPreservationPriority(0.0, forTags: tagsSet) // value between 0.0 and 1.0, minimum value will be deleted immediately
        
        let resourceRequest: NSBundleResourceRequest = NSBundleResourceRequest(tags: tagsSet)
        resourceRequest.endAccessingResources()
        
        resourceRequest.loadingPriority = NSBundleResourceRequestLoadingPriorityUrgent // value between 0.0 and 1.0, urgent will have most priority and resources will be downloaded immediatelly
        
        addDownloadProgressObserver(toRequest: resourceRequest)
        resourceRequest.conditionallyBeginAccessingResources(completionHandler: { (resourcesAvailable: Bool) -> Void in
            
            if resourcesAvailable {
                print("odrResources already available")
                completion(.success(true))
            } else {
                
                resourceRequest.beginAccessingResources(completionHandler: { (err) in
                    if let error = err {
                        completion(.failure(error as NSError))
                        print("Error: \(error)")
                    } else {
                        print("odrResources loading")
                        completion(.success(true))
                    }
                })
            }
        })
    }
}

// MARK: Observe resource download progress
extension ODRManager {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == progressObservingContext
            && keyPath == ODRManager.progressObservingKeyPath {
            print("ODR Progress: \(Float((object as! Progress).fractionCompleted))")
        }
    }
    
    private func addDownloadProgressObserver(toRequest request: NSBundleResourceRequest) {
        request.progress.addObserver(self,
                                             forKeyPath: ODRManager.progressObservingKeyPath,
                                             options: [.new, .initial],
                                             context: self.progressObservingContext)
    }
}

public enum ODRResult<Success, Failure: Error> {
    case success(Success)
    case failure(Failure)
}
