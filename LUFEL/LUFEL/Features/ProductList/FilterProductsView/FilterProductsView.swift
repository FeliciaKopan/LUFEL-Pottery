//
//  FilterProductsView.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 01.08.2024.
//

import UIKit
import Combine

//enum ProductType: String {
//    case cups = "Cani"
//    case plates = "Farfurii"
//    case vases = "Vaze"
//    case bowls = "Boluri"
//
//    var title: String {
//        return self.rawValue
//    }
//}

enum ProductColor: String, Codable {
    case alb = "Alb"
    case albastru = "Albastru"
    case galben = "Galben"

    var title: String {
        return self.rawValue
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
    private let colorFilters: [ProductColor] = [.alb, .galben, .albastru]

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
        print("Applying filters: \(selectedFilters)")
        selectedSubject.send(selectedFilters)
        clearAllButton.isHidden = selectedFilters.isEmpty
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

//        typeFilterView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showTypeFilters)))
        colorFilterView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showColorFilters)))
    }

//    @objc private func showTypeFilters() {
//        isFilteringByType = true
//        selectedFilters = typeFilters.map { $0.title }
//        print(selectedFilters)
//        collectionView.reloadData()
//    }

    @objc private func showColorFilters() {
        selectedFilters = colorFilters.map { $0.title }
        collectionView.reloadData()
    }
}

extension FilterProductsView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filter = colorFilters[indexPath.item].title
        if let index = selectedFilters.firstIndex(of: filter) {
            selectedFilters.remove(at: index)
        } else {
            selectedFilters.append(filter)
        }
        print("Selected Filters after selection: \(selectedFilters)")
        
        collectionView.reloadItems(at: [indexPath])
        clearAllButton.isHidden = selectedFilters.isEmpty
    }
}

extension FilterProductsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorFilters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCollectionViewCell", for: indexPath) as! FilterCollectionViewCell
        let filter = colorFilters[indexPath.row].title
        let isSelected = selectedFilters.contains(filter)
        cell.configure(title: filter, isSelected: isSelected)
        return cell
    }
}

extension FilterProductsView: UICollectionViewDelegateFlowLayout {
    func collectionView(
      _ collectionView: UICollectionView,
      layout collectionViewLayout: UICollectionViewLayout,
      sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let filterTitle = colorFilters[indexPath.item].title
        let font = UIFont.systemFont(ofSize: 17)
        let size = filterTitle.size(withAttributes: [NSAttributedString.Key.font: font])
        return CGSize(width: size.width + 20, height: size.height + 20)
    }
}
