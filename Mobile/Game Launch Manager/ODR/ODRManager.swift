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
    private let progressObservingKeyPath = "fractionCompleted"
    var progressObservingContext: UnsafeMutableRawPointer?

    override private init() { super.init() } // For Singleton Pattern

    public func loadResourcesWithTags(_ tagArray: [String],
                                      _ completion: @escaping (Result<Void, Error>) -> Void) {
        let tagSet = Set(tagArray)

        Bundle.main.setPreservationPriority(0.0, forTags: tagSet) // value between 0.0 and 1.0, minimum value will be deleted immediately

        let resourceRequest: NSBundleResourceRequest = NSBundleResourceRequest(tags: tagSet)
        resourceRequest.endAccessingResources()

        resourceRequest.loadingPriority = NSBundleResourceRequestLoadingPriorityUrgent // value between 0.0 and 1.0, urgent will have most priority and resources will be downloaded immediatelly

        addDownloadProgressObserver(toRequest: resourceRequest)

        resourceRequest.conditionallyBeginAccessingResources(completionHandler: { (resourcesAvailable: Bool) -> Void in
            if resourcesAvailable {
                completion(.success(()))
            } else {
                resourceRequest.beginAccessingResources(completionHandler: { error in
                    let result: Result<Void, Error>
                    if let error = error {
                        result = .failure(error)
                    } else {
                        result = .success(())
                    }
                    completion(result)
                })
            }
        })
    }
}

// MARK: Observe resource download progress
extension ODRManager {
    // swiftlint:disable block_based_kvo
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey: Any]?,
                               context: UnsafeMutableRawPointer?) {
        if context == progressObservingContext,
           keyPath == progressObservingKeyPath {
            // swiftlint:disable force_cast
            print("ODR.Progress:", "\(Float((object as! Progress).fractionCompleted))")
        }
    }

    private func addDownloadProgressObserver(toRequest request: NSBundleResourceRequest) {
        request.progress.addObserver(self,
                                     forKeyPath: progressObservingKeyPath,
                                     options: [.new, .initial],
                                     context: self.progressObservingContext)
    }
}
