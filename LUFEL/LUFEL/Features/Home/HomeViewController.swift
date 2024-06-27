//
//  HomeViewController.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 14.06.2024.
//

import UIKit
import AVFoundation
import Combine

class HomeViewController: UIViewController {

    // MARK: - Views

    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var swipeUpView: UIView!

    // MARK: - Properties

    private var videoPlayer: AVPlayer?
    private var videoPlayerLayer: AVPlayerLayer?
    private let homeDetailsView = HomeDetailsView()

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Lifecycle

    override func loadView() {
        view = viewFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupVideoPlayer()
        setupSwipeUpView()
        setupHomeDetailsView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        (parent as? MainTabViewController)?.update(color: .red)
    }

    // MARK: - Private Methods

    private func setupVideoPlayer() {
        guard let videoPath = Bundle.main.path(forResource: "video", ofType: "mp4") else {
            print("Video not found")
            return
        }

        let videoURL = URL(fileURLWithPath: videoPath)
        videoPlayer = AVPlayer(url: videoURL)
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer)
        videoPlayerLayer?.frame = playerView.bounds
        videoPlayerLayer?.videoGravity = .resizeAspectFill

        if let videoPlayerLayer = videoPlayerLayer {
            playerView.layer.addSublayer(videoPlayerLayer)
        }

        videoPlayer?.play()
        videoPlayer?.actionAtItemEnd = .none

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(videoDidEnd),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: videoPlayer?.currentItem)
    }

    @objc private func videoDidEnd(notification: NSNotification) {
        videoPlayer?.seek(to: CMTime.zero)
        videoPlayer?.play()
    }

    private func setupSwipeUpView() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        swipeUpView.addGestureRecognizer(panGesture)
    }

    private func setupHomeDetailsView() {
        homeDetailsView.frame = view.bounds
        homeDetailsView.frame.origin.y = view.bounds.height
        view.addSubview(homeDetailsView)
    }

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)

        switch gesture.state {
        case .changed:
            if translation.y < 0 {
                homeDetailsView.frame.origin.y = view.bounds.height + translation.y
            }
        case .ended:
            if velocity.y < 0 {
                UIView.animate(withDuration: 0.3) {
                    self.homeDetailsView.frame.origin.y = 0
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.homeDetailsView.frame.origin.y = self.view.bounds.height
                }
            }
        default:
            break
        }
    }
}
