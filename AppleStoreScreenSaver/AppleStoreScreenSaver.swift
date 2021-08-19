//
//  AppleStoreScreenSaver.swift
//  AppleStoreScreenSaver
//
//  Created by Alexandre Podlewski on 13/08/2021.
//

import Foundation
import ScreenSaver
import AVKit

class AppleStoreScreenSaver: ScreenSaverView {
    private var player: AVPlayer!
    private var playerLayer: AVPlayerLayer!

    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        animationTimeInterval = 1.0 / 30.0
        wantsLayer = true
        player = createAVPlayer()
        playerLayer = createAVPlayerLayer(player: player)
        self.layer = playerLayer
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func startAnimation() {
        super.startAnimation()
        player.play()
    }

    override func stopAnimation() {
        super.stopAnimation()
        player.pause()
    }

    func createAVPlayer() -> AVPlayer {
        let moonBundle: Bundle = Bundle(for: AppleStoreScreenSaver.self)
        guard let url = moonBundle.url(forResource: "video", withExtension: "mp4") else {
            fatalError("video.mp4 not found in \(moonBundle.bundlePath)")
        }
        let avPlayer = AVPlayer(url: url)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerItemDidReachEnd),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: nil
        )
        return avPlayer
    }

    func createAVPlayerLayer(player: AVPlayer) -> AVPlayerLayer {
        let avPlayerLayer: AVPlayerLayer = AVPlayerLayer(player: player)
        avPlayerLayer.frame = bounds
        avPlayerLayer.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
        avPlayerLayer.needsDisplayOnBoundsChange = true
        avPlayerLayer.contentsGravity = .resizeAspect
        avPlayerLayer.backgroundColor = CGColor(red: 0.00, green: 0.01, blue: 0.00, alpha:1.0)
        return avPlayerLayer
    }

    @objc func playerItemDidReachEnd(notification: NSNotification) {
        player.seek(to: CMTime.zero)
        player.play()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
