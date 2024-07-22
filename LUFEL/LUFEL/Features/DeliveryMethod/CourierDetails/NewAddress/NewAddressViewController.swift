//
//  NewAddressViewController.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 03.07.2024.
//

import UIKit
import Combine

class NewAddressViewController: UIViewController {

    // MARK: - Views

    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var countyView: UIView!
    @IBOutlet weak var countyAndLocalityLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    
    // MARK: - Properties

    private var newOrder: NewOrder
    private var counties: [County] = []
    private var selectedCounty: County?
    private var selectedLocality: String?
    private var cancellables = Set<AnyCancellable>()

    @Injected(\.countyProvider) var countyProvider: CountyProviding

    // MARK: - Initializer

    init(newOrder: NewOrder) {
        self.newOrder = newOrder
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupCountyView()
        setupSaveButton()
        setupPickerView()
        loadCounties()
    }

    // MARK: - Private methods

    private func setupCountyView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(countyViewTapped))
        countyView.addGestureRecognizer(tapGesture)
    }

    private func setupNavigationBar() {
        navigationItem.title = "Adauga adresa noua"
        navigationController?.navigationBar.tintColor = .gray

        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
    }

    private func setupPickerView() {
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.isHidden = true
    }

    private func loadCounties() {
        countyProvider.fetchCounties()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error fetching counties: \(error)")
                }
            }, receiveValue: { [weak self] counties in
                self?.counties = counties
                self?.pickerView.reloadAllComponents()
            })
            .store(in: &cancellables)
    }

    private func setupSaveButton() {
        saveButton.addTarget(self, action: #selector(saveAddress), for: .touchUpInside)
    }

    @objc private func saveAddress() {
        guard let address = addressTextField.text, !address.isEmpty else { return }
        newOrder.address = address
        navigationController?.popViewController(animated: true)
    }

    @objc private func countyViewTapped() {
        pickerView.isHidden = false
        view.endEditing(true)
    }
}

extension NewAddressViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return counties.count
        } else if component == 1 {
            return selectedCounty?.localities.count ?? 0
        }
        return 0
    }
}

extension NewAddressViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return counties[row].name
        } else if component == 1 {
            return selectedCounty?.localities[row]
        }
        return nil
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedCounty = counties[row]
            selectedLocality = selectedCounty?.localities.first
            pickerView.reloadComponent(1)
            pickerView.selectRow(0, inComponent: 1, animated: true)
        } else if component == 1 {
            selectedLocality = selectedCounty?.localities[row]
            if let county = selectedCounty, let locality = selectedLocality {
                countyAndLocalityLabel.text = "\(county.name), \(locality)"
                pickerView.isHidden = true
            }
        }
    }
}
