//
//  HomeDetailsView.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 27.06.2024.
//

import UIKit
import MapKit

class HomeDetailsView: UIView, NibLoadable {

    // MARK: - Views

    @IBOutlet weak var swipeDownView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
        setupGesture()
        setupMapView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNibContent()
        setupGesture()
        setupMapView()
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

    private func setupMapView() {
        let annotation = MKPointAnnotation()
        annotation.title = "LUFEL"
        annotation.subtitle = "Ceramica lucrată manual"
        annotation.coordinate = CLLocationCoordinate2D(latitude: 46.1504517, longitude: 24.3487743)
        mapView.addAnnotation(annotation)
        mapView.showAnnotations([annotation], animated: true)
    }
}
