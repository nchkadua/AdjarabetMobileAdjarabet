//
//  SportViewController.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/14/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import UIKit
import WebKit
/*import GCDWebServer
import Zip*/

public class SportsViewController: UIViewController {
    public override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    @Inject(from: .useCases) private var gameLauncherUseCase: GameLauncherUseCase
    @Inject public var userSession: UserSessionServices

    private lazy var webView: WKWebView = {
        WKWebView()
    }()
    /*var webServer = GCDWebServer()*/

    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
//        initWebServer()
        getLaunchUrl()
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgorundColor()
        makeAdjarabetLogo()
        navigationItem.rightBarButtonItem = makeBalanceBarButtonItem().barButtonItem
        setupWebView()
    }

    private func initWebServer(_ launchUrl: String) {
        /*let path = unzip().appendingPathComponent(launchUrl)
//        let url = URL(fileURLWithPath: path, isDirectory: false).appendingPathComponent(testUrl)
        print("webServer.serverURL ", path)
        webServer.addGETHandler(forBasePath: "/", directoryPath: path.absoluteString, indexFilename: "index.html", cacheAge: 0, allowRangeRequests: true)
        webServer.start(withPort: 8080, bonjourName: "GCD Web Server")*/
        webView.load(URLRequest(url: URL(string: launchUrl)!))

        /*let fileManager = FileManager.default

        do {
            let docsArray = try fileManager.contentsOfDirectory(atPath: Bundle.main.resourceURL!.appendingPathComponent("TemporaryGameResources/GameBundle").path)
            print("asdasda ", docsArray)
        } catch {
            print("asdasda ", error)
        }*/
    }

    private func setupWebView() {
        webView.translatesAutoresizingMaskIntoConstraints = false

        webView.configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        webView.configuration.setValue("TRUE", forKey: "allowUniversalAccessFromFileURLs")
        webView.configuration.preferences.javaScriptEnabled = true

        view.addSubview(webView)
        webView.pin(to: view)
    }

    /*func unzip () -> URL {
        do {
            let filePath = Bundle.main.url(forResource: "GameBundle", withExtension: "zip")! //, subdirectory: "Presentation/MainPages/Sports/TemporaryGameResources"
            let unzipDirectory = try Zip.quickUnzipFile(filePath) // Unzip
            return unzipDirectory
        } catch {
            return URL(fileURLWithPath: "")
        }
    }*/
}

extension SportsViewController: CommonBarButtonProviding { }

extension SportsViewController {
    func getLaunchUrl() {
        // EGT "11e7b7ca-14f1-b0b0-88fc-005056adb106"
        gameLauncherUseCase.execute(params: .init(gameId: "7382", providerId: "11e7b7ca-14f1-b0b0-88fc-005056adb106")) { result in
            switch result {
            case .success(let launchUrl): self.initWebServer(launchUrl.url ?? "")
            case .failure(let error): print(error)
            }
        }
    }
}
