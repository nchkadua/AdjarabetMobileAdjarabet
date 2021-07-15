//
//  VideoCardComponentView.swift
//  Mobile
//
//  Created by Irakli Shelia on 1/21/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift
import AVFoundation

class VideoCardComponentView: UIView {
    private var disposeBag = DisposeBag()
    private var viewModel: VideoCardComponentViewModel!
    private var playerLooper: AVPlayerLooper!
    private var queuePlayer: AVQueuePlayer!
    private var playerLayer: AVPlayerLayer!
    // MARK: Outlets
    @IBOutlet weak private var view: UIView!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        setupPlayer()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(radius: 10)
        playerLayer.frame = self.view.bounds
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        nibSetup()
    }

    public func setAndBind(viewModel: VideoCardComponentViewModel) {
        self.viewModel = viewModel
        bind()
    }

    private func bind() {
        disposeBag = DisposeBag()
        viewModel?.action.subscribe(onNext: { _ in
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    private func setupPlayer() {
        let playerItem = AVPlayerItem(asset: VideoCardComponentView.videoAssetFlyweight)
        queuePlayer = AVQueuePlayer(playerItem: playerItem)
        playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
        playerLayer = AVPlayerLayer(player: queuePlayer)
        view.layer.addSublayer(playerLayer)
        playerLayer.videoGravity = .resizeAspectFill
        queuePlayer.isMuted = true
        queuePlayer.play()
    }
}

extension VideoCardComponentView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue
        }
    }

    func setupUI() {
        view.setBackgorundColor(to: .secondaryBg())
    }
}

extension VideoCardComponentView {
    private static var videoAssetFlyweight: AVAsset {
        return AVAsset(url: URL(fileURLWithPath: Bundle.main.path(forResource: "incognito-card", ofType: "mp4")!))
    }
}
