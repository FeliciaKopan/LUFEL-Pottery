//
//  EasyboxDetailView.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 03.07.2024.
//

import UIKit
import MapKit

class EasyboxDetailView: UIView, NibLoadable {

    // MARK: - Views

    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNibContent()

    }

    // MARK: - Private methods
}
