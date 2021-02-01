//
//  ODRManager.swift
//  Mobile
//
//  Created by Nika Chkadua on 1/26/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

class ODRManager {
    static let shared = ODRManager()
    
    public var progressObservingContext = 0
    
    public func loadResourcesWithTags(_ tagArray: Array<String>, completion: @escaping ((ODRResult<Bool, NSError>) -> Void)) {
        
        let tags = NSSet(array: tagArray)
        let tagsSet = tags as! Set<String>
        
        Bundle.main.setPreservationPriority(0.0, forTags: tagsSet) // value between 0.0 and 1.0, minimum value will be deleted immediately
        
        let resourceRequest: NSBundleResourceRequest = NSBundleResourceRequest(tags: tagsSet)
        resourceRequest.endAccessingResources()
        
        resourceRequest.loadingPriority = NSBundleResourceRequestLoadingPriorityUrgent // value between 0.0 and 1.0, urgent will have most priority and resources will be downloaded immediatelly
        resourceRequest.conditionallyBeginAccessingResources(completionHandler: { (resourcesAvailable: Bool) -> Void in
            
            if resourcesAvailable {
//                print("odrResources already available")
                completion(.success(true))
            } else {
                
                resourceRequest.beginAccessingResources(completionHandler: { (err) in
                    if let error = err {
                        completion(.failure(error as NSError))
                        print("Error: \(error)")
                    } else {
//                        print("odrResources loading")
                        completion(.success(true))
                    }
                })
            }
        })
    }
}

public enum ODRResult<Success, Failure: Error> {
    case success(Success)
    case failure(Failure)
}
