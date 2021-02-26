//
//  FileExtractor.swift
//  Mobile
//
//  Created by Nika Chkadua on 1/27/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation
import ZIPFoundation

class FileExtractor: NSObject {
    // Directories
    private let fileManager = FileManager()
    private let directoryName = "DownloadedResources"

    public static let shared = FileExtractor()

    public func extractFileWithName(_ name: String, _ fileExtension: String = "zip", completion: @escaping ((ExtractResult<NSString, NSString>) -> Void)) {
        do {
            print(name, fileExtension)
            let filePath = Bundle.main.url(forResource: name, withExtension: fileExtension)!

            let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
            let downloadedResourcesPath = documentsPath.appendingPathComponent(directoryName)!
            do {
                try FileManager.default.createDirectory(atPath: downloadedResourcesPath.relativePath, withIntermediateDirectories: true, attributes: nil)
                do {
                    try fileManager.createDirectory(at: downloadedResourcesPath, withIntermediateDirectories: true, attributes: nil)
                    try fileManager.unzipItem(at: filePath, to: downloadedResourcesPath)

                    completion(.success(downloadedResourcesPath.appendingPathComponent(name).relativePath as NSString))
                    /// Temp: Check for unzipped files
                    do {
                        let fullPath = downloadedResourcesPath.appendingPathComponent("bundles")
                        print("ODResources contains: fullPath ", fullPath)
                        let docsArray = try fileManager.contentsOfDirectory(atPath: fullPath.relativePath)
                        print("ODResources contains: ", docsArray)
                    } catch {
                        print("ODResources: ", error)
                    }
                } catch {
                    completion(.failure("ODResources: Extraction of ZIP archive failed with error:\(error)" as NSString))
                }
            } catch let error as NSError {
                completion(.failure("ODResources: Unable to create directory \(error.debugDescription)" as NSString))
            }
        }
    }

    func clearUnzippedResourcesFolder() {
        let fileManager = FileManager.default
        let tempFolderPath = NSTemporaryDirectory()
        do {
            let filePaths = try fileManager.contentsOfDirectory(atPath: tempFolderPath)
            for filePath in filePaths {
                try fileManager.removeItem(atPath: tempFolderPath + filePath)
            }
        } catch {
            print("ODResources: Could not clear temp folder: \(error)")
        }
    }

    // MARK: App Lifecycle Observation
    private override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillTerminate), name: UIApplication.willTerminateNotification, object: nil)
    }

    @objc private func applicationWillTerminate() {
        clearUnzippedResourcesFolder()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

public enum ExtractResult<Success: NSString, Failure: NSString> {
    case success(Success)
    case failure(Failure)
}
