//
//  HomeDetailsView.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 27.06.2024.
//

import UIKit

class HomeDetailsView: UIView, NibLoadable {

    // MARK: - Views

    @IBOutlet weak var swipeDownView: UIView!

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
        setupGesture()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNibContent()
        setupGesture()
    }

    // MARK: - Private methods

    private func setupGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        swipeDownView.addGestureRecognizer(panGesture)
    }

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let parentView = superview else { return }
        let translation = gesture.translation(in: parentView)
        let velocity = gesture.velocity(in: parentView)

        switch gesture.state {
        case .changed:
            if translation.y > 0 {
                self.frame.origin.y = translation.y
            }
        case .ended:
            if velocity.y > 0 {
                UIView.animate(withDuration: 0.3) {
                    self.frame.origin.y = parentView.bounds.height
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.frame.origin.y = 0
                }
            }
        default:
            break
        }
    }

}
