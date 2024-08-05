//
//  PickupDetailView.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 03.07.2024.
//

import UIKit
import MapKit

class PickupDetailView: UIView, NibLoadable {

    // MARK: - Views

    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
        setupMapView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNibContent()
        setupMapView()
    }

    // MARK: - Private methods

    private func setupMapView() {
        mapView.delegate = self

        let annotation = MKPointAnnotation()
        annotation.title = "LUFEL"
        annotation.subtitle = "Ceramica lucrată manual"
        annotation.coordinate = CLLocationCoordinate2D(latitude: 46.1504517, longitude: 24.3487743)
        mapView.addAnnotation(annotation)
        mapView.showAnnotations([annotation], animated: true)
    }

    private func findViewController() -> UIViewController? {
        var nextResponder: UIResponder? = self
        while nextResponder != nil {
            nextResponder = nextResponder?.next
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

extension PickupDetailView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let coordinate = view.annotation?.coordinate else { return }

        let alertController = UIAlertController(title: "Open in Maps", message: "Do you want to open this location in Maps?", preferredStyle: .alert)
        let openAction = UIAlertAction(title: "Open", style: .default) { _ in
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
            mapItem.name = view.annotation?.title ?? "Location"
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(openAction)
        alertController.addAction(cancelAction)

        if let viewController = self.findViewController() {
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
}
