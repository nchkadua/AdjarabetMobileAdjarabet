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

        guard viewModel != nil else {return}
        setupPlayer(with: viewModel.params.pathType)
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
        viewModel?.action.subscribe(onNext: { [weak self] action in
            guard let self = self else { return }
            switch action {
            case .setAssetWith(let pathType): self.setupPlayer(with: pathType)
            }
        }).disposed(by: disposeBag)

        viewModel.didBind()
    }

    private func setupPlayer(with pathType: AssetPathType) {
        let playerItem = AVPlayerItem(asset: videoAssetFlyweight(with: pathType))
        queuePlayer = AVQueuePlayer(playerItem: playerItem)
        playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
        playerLayer = AVPlayerLayer(player: queuePlayer)
        view.layer.addSublayer(playerLayer)
        playerLayer.videoGravity = .resizeAspectFill
        queuePlayer.isMuted = true
        queuePlayer.play()
    }

    private func videoAssetFlyweight(with pathType: AssetPathType) -> AVAsset {
        switch pathType {
        case .bundle(let name, let extenstion):
            return AVAsset(url: URL(fileURLWithPath: Bundle.main.path(forResource: name, ofType: extenstion)!))
        case .url(let url):
            if let url = URL(string: url) {
                return AVAsset(url: url)
            }
        }
        return AVAsset()
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
