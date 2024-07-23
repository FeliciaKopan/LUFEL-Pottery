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
    @Injected(\.addressProvider) var addressProvider: AddressProviding

    lazy var addressPublisher = addressSubject.eraseToAnyPublisher()
    private let addressSubject = PassthroughSubject<AddressDetails, Never>()

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
        setupTextFields()
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

    private func setupTextFields() {
        fullNameTextField.delegate = self
        phoneNumberTextField.delegate = self
        addressTextField.delegate = self

        fullNameTextField.autocorrectionType = .no
        phoneNumberTextField.autocorrectionType = .no
        addressTextField.autocorrectionType = .no

        updateSaveButtonState()
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
        saveButton.isEnabled = false
        updateSaveButtonStyle()
    }

    private func isValidName(_ name: String) -> Bool {
        let regex = "^[A-Za-z ]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: name) && name.split(separator: " ").allSatisfy { $0.first?.isUppercase ?? false }
    }

    private func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let regex = "^[0-9]{10}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: phoneNumber)
    }

    private func updateSaveButtonState() {
        let isFullNameValid = fullNameTextField.text.flatMap(isValidName) ?? false
        let isPhoneNumberValid = phoneNumberTextField.text.flatMap(isValidPhoneNumber) ?? false
        let isAddressValid = !(addressTextField.text?.isEmpty ?? true)
        let isCountyAndLocalitySelected = selectedCounty != nil && selectedLocality != nil

        print("\(isFullNameValid), \(isPhoneNumberValid), \(isAddressValid), \(isCountyAndLocalitySelected)")

        saveButton.isEnabled = isFullNameValid && isPhoneNumberValid && isAddressValid && isCountyAndLocalitySelected
        updateSaveButtonStyle()
    }

    private func updateSaveButtonStyle() {
        if saveButton.isEnabled {
            saveButton.backgroundColor = .black
            saveButton.setTitleColor(.white, for: .normal)
        } else {
            saveButton.backgroundColor = .lightGray
            saveButton.setTitleColor(.darkGray, for: .normal)
        }
    }

    @objc private func saveAddress() {
        guard let fullName = fullNameTextField.text, isValidName(fullName),
              let phoneNumber = phoneNumberTextField.text, isValidPhoneNumber(phoneNumber),
              let address = addressTextField.text, !address.isEmpty,
              let county = selectedCounty?.name,
              let locality = selectedLocality else {
            return
        }

        let addressDetails = AddressDetails(
            fullName: fullName,
            phoneNumber: phoneNumber,
            address: address,
            county: county,
            locality: locality
        )

        newOrder.addressDetails = addressDetails
        addressSubject.send(addressDetails)
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

        updateSaveButtonState()
    }
}

extension NewAddressViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == fullNameTextField {
            let allowedCharacters = CharacterSet.letters.union(.whitespaces)

            return string.rangeOfCharacter(from: allowedCharacters.inverted) == nil
        } else if textField == phoneNumberTextField {
            let allowedCharacters = CharacterSet.decimalDigits
            return string.rangeOfCharacter(from: allowedCharacters.inverted) == nil
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == fullNameTextField, let text = textField.text {
            textField.text = text.split(separator: " ").map { $0.capitalized }.joined(separator: " ")
        }
    }
}
