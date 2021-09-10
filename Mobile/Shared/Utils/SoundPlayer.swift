//
//  SoundPlayer.swift
//  Mobile
//
//  Created by Nika Chkadua on 09.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation
import AVFoundation

class SoundPlayer {
    static let shared = SoundPlayer()
    private var player: AVAudioPlayer?

    public func playSound(_ name: String, _ extenstion: String = "mp3") {
        guard let url = Bundle.main.url(forResource: name, withExtension: extenstion) else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }

            player.play()
        } catch {
            print(error.localizedDescription)
        }
    }
}
