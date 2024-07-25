//
//  OrderCompletionView.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 25.07.2024.
//

import UIKit
import Lottie

class OrderCompletionView: UIView, NibLoadable {

    // MARK: - Views

    @IBOutlet weak var animationContainerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Properties

    private let animationView = LottieAnimationView()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNibContent()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        animationView.frame = animationContainerView.bounds
    }

    // MARK: - Actions

    @IBAction func finishButton(_ sender: Any) {

    }

    // MARK: - Public methods

    func setAnimation() {
        animationContainerView.addSubview(animationView, withEdgeInsets: .zero)
        LottieConfiguration.shared.renderingEngine = .mainThread
        let animation = LottieAnimation.named("SuccessAnimation")
        LottieConfiguration.shared.renderingEngine = .mainThread
        animationView.animation = animation
        animationView.loopMode = .playOnce
        animationView.animationSpeed = 1
        animationView.contentMode = .scaleAspectFill
        animationView.play()
    }
}
