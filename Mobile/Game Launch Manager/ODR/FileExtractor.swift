//
//  FileExtractor.swift
//  Mobile
//
//  Created by Nika Chkadua on 1/27/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import ZIPFoundation

class FileExtractor {
    static let shared = FileExtractor()
    private let fileManager = FileManager.default
    private let directoryName = "DownloadedResources"

    private init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillTerminate),
                                               name: UIApplication.willTerminateNotification,
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func applicationWillTerminate() {
        clearUnzippedResourcesFolder()
    }

    func clearUnzippedResourcesFolder(_ handler: ((Result<Void, Error>) -> Void)? = nil) {
        guard let resources = resources
        else {
            handler?(.success(())) // For some reason resources does not exist, so they are already deleted
            return
        }
        do {
            let files = try fileManager.contentsOfDirectory(atPath: resources.relativePath)
            for file in files {
                try fileManager.removeItem(atPath: resources.appendingPathComponent(file).relativePath)
            }
            handler?(.success(()))
        } catch {
            handler?(.failure(error))
        }
    }

    public func extractFileWithName(_ name: String,
                                    _ fileExtension: String = "zip",
                                    _ completion: @escaping (Result<String, Error>) -> Void) {
        guard let filePath = Bundle.main.url(forResource: name, withExtension: fileExtension),
              let resources = resources
        else {
            completion(.failure(AdjarabetCoreClientError.coreError(description: "File Not Found")))
            return
        }

        do {
            try fileManager.createDirectory(at: resources, withIntermediateDirectories: true, attributes: nil)
            try fileManager.unzipItem(at: filePath, to: resources)
            completion(.success(resources.appendingPathComponent(name).relativePath))
        } catch {
            completion(.failure(error))
        }
    }

    private var resources: URL? {
        let pathForDirs = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        guard !pathForDirs.isEmpty
        else { return nil }
        let documents = NSURL(fileURLWithPath: pathForDirs[0])
        return documents.appendingPathComponent(directoryName)
    }
}
