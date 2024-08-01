//
//  FilterProductsView.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 01.08.2024.
//

import UIKit
import Combine

enum ProductType {
    case cups
    case plates
    case vases
    case bowls

    var title: String {
        switch self {
        case .cups:
            return "Cani"
        case .plates:
            return "Farfurii"
        case .vases:
            return "Vaze"
        case .bowls:
            return "Boluri"
        }
    }
}

enum ProductColor {
    case white
    case blue
    case yellow

    var title: String {
        switch self {
        case .blue:
            return "Albastru"
        case .white:
            return "Alb"
        case .yellow:
            return "Galben"
        }
    }
}

class FilterProductsView: UIView, NibLoadable {

    // MARK: - Views

    @IBOutlet weak var typeFilterView: UIView!
    @IBOutlet weak var colorFilterView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var clearAllButton: UIButton!
    @IBOutlet weak var showAllButton: UIButton!

    // MARK: - Properties

    private var selectedFilters: [String] = []
    private var isFilteringByType = false
    private let typeFilters: [ProductType] = [.bowls, .cups, .plates, .vases]
    private let colorFilters: [ProductColor] = [.blue, .yellow, .white]

    // MARK: - Publishers

    lazy var selectedPublisher = selectedSubject.eraseToAnyPublisher()
    private let selectedSubject = PassthroughSubject<[String], Never>()

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
        setupCollectionView()
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNibContent()
        setupCollectionView()
        setupViews()
    }

    // MARK: - Actions

    @IBAction func clearSelectedItems(_ sender: Any) {
        selectedFilters.removeAll()
        clearAllButton.isHidden = true
        collectionView.reloadData()
    }
    
    @IBAction func applyFilters(_ sender: Any) {
        selectedSubject.send(selectedFilters)
    }
    
    // MARK: - Private methods

    private func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.layoutIfNeeded()
        collectionView.registerCell(type: FilterCollectionViewCell.self)
        let layout: UICollectionViewFlowLayout = LeftAlignedCollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout
    }

    private func setupViews() {
        clearAllButton.isHidden = true

        typeFilterView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showTypeFilters)))
        colorFilterView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showColorFilters)))
    }

    @objc private func showTypeFilters() {
        isFilteringByType = true
        selectedFilters = typeFilters.map { $0.title }
        print(selectedFilters)
        collectionView.reloadData()
    }

    @objc private func showColorFilters() {
        isFilteringByType = false
        selectedFilters = colorFilters.map { $0.title }
        print(selectedFilters)
        collectionView.reloadData()
    }
}

extension FilterProductsView: UICollectionViewDelegate {

}

extension FilterProductsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedFilters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCollectionViewCell", for: indexPath) as! FilterCollectionViewCell
        let filter = selectedFilters[indexPath.row]
        cell.configure(title: filter)
        return cell
    }
}

extension FilterProductsView: UICollectionViewDelegateFlowLayout {
    func collectionView(
      _ collectionView: UICollectionView,
      layout collectionViewLayout: UICollectionViewLayout,
      sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if let manropeFont = UIFont(name: "Helvetica", size: 17) {
            let wordSize = selectedFilters[indexPath.item].cgSize(usingFont: manropeFont)

            return CGSize(width: wordSize.width + 32, height: 40)

        }
        return CGSize(width: 0, height: 0)
    }
}
