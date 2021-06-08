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
    private var gameDirectory: String { randomString(length: 32) }

    private init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillTerminate),
                                               name: UIApplication.willTerminateNotification,
                                               object: nil)
    }

    @objc private func applicationWillTerminate() {
        clearUnzippedResourcesFolder()
    }

    func clearUnzippedResourcesFolder(named: String? = nil, _ handler: ((Result<Void, Error>) -> Void)? = nil) {
        guard let resources = resources
        else {
            handler?(.success(())) // For some reason resources does not exist, so they are already deleted
            return
        }
        let path: String
        if let named = named {
            path = named
        } else {
            path = resources.relativePath
        }
        do {
            try fileManager.removeItem(atPath: path)
            handler?(.success(()))
        } catch {
            handler?(.failure(error))
        }
    }

    public func extractFileWithName(_ name: String,
                                    _ fileExtension: String = "zip",
                                    _ completion: @escaping (Result<(String, String), Error>) -> Void) {
        guard let filePath = Bundle.main.url(forResource: name, withExtension: fileExtension),
              var resources = resources
        else {
            completion(.failure(AdjarabetCoreClientError.coreError(description: "File Not Found")))
            return
        }
        resources = resources.appendingPathComponent(gameDirectory)
        do {
            try fileManager.createDirectory(at: resources, withIntermediateDirectories: true, attributes: nil)
            try fileManager.unzipItem(at: filePath, to: resources)
            completion(.success((resources.relativePath, name)))
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

    private func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in letters.randomElement()! })
    }
}
