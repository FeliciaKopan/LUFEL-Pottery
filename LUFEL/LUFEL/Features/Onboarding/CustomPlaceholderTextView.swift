//
//  CustomPlaceholderTextView.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 07.06.2024.
//

import UIKit
import Combine

class CustomPlaceholderTextView: UIView {

    enum CustomPlaceholderType {
        case name
        case email
        case password
    }

    // MARK: - Views

    private let textView = UITextField()
    private let placeholderLabel = UILabel()
    private let numberOfCharactersLabel = UILabel()
    private let textContainer = UIView()
    private let nameMaskView = UIView()
    private let maskLabel = UILabel()

    // MARK: - Properties

    private var cancellables = Set<AnyCancellable>()
    private var maxNumberOfCharaters = 120
    weak var delegate: CustomPlaceholderTextViewDelegate?
    private var allowedCharacterSet: CharacterSet?

    private lazy var numberOfCharactersLabelTrailingAnchor = numberOfCharactersLabel
        .trailingAnchor
        .constraint(
            equalTo: textContainer.trailingAnchor,
            constant: -16
        )

    private lazy var nameMaskViewWidthAnchor = nameMaskView.widthAnchor.constraint(equalToConstant: 70)

    private var allowIsSelected = false
    private var isPassword = false

    // MARK: - Publishers

    lazy var textPublisher = textView.publisher(for: \.text)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupViews()
    }

    // MARK: - Public methods

    func configure(type: CustomPlaceholderType, existingText: String?, placeholder: String?, maxNumberOfCharaters: Int?) {
        setMaskText(placeholder)
        switch type {
        case .name:
            textView.textContentType = .name
            if let maxNumberOfCharaters = maxNumberOfCharaters {
                self.maxNumberOfCharaters = maxNumberOfCharaters
            }
            if let existingText = existingText {
                textView.text = existingText
                setupNumberOfCharacters(name: existingText)
            }
            allowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890 ")
        case .email:
            textView.keyboardType = .emailAddress
            textView.tintColor = .lightGrey
            textView.textContentType = .emailAddress
            textView.autocorrectionType = .no
            textView.autocapitalizationType = .none
            allowIsSelected = true
            numberOfCharactersLabel.isHidden = true
            numberOfCharactersLabelTrailingAnchor.constant = 0
            numberOfCharactersLabel.widthAnchor.constraint(equalToConstant: 0).isActive = true
            placeholderLabel.text = placeholder
            nameMaskView.isHidden = true
            nameMaskViewWidthAnchor.constant = maskLabel.intrinsicContentSize.width + 15
            layoutIfNeeded()
        case .password:
            textView.textColor = .lufelRed
            textView.tintColor = .lufelRed
            textView.textContentType = .password
            textView.autocorrectionType = .no
            textView.autocapitalizationType = .none
            textView.isSecureTextEntry = true
            allowIsSelected = true
            numberOfCharactersLabel.isHidden = true
            numberOfCharactersLabelTrailingAnchor.constant = 0
            numberOfCharactersLabel.widthAnchor.constraint(equalToConstant: 0).isActive = true
            placeholderLabel.text = placeholder
            nameMaskView.isHidden = true
            nameMaskViewWidthAnchor.constant = maskLabel.intrinsicContentSize.width + 15
            layoutIfNeeded()
        }
    }

    func configure(currentName: String?, placeholder: String?) {
        textView.text = currentName
        setMaskText(placeholder)
        if let currentName = currentName {
            setupNumberOfCharacters(name: currentName)
        }
        allowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890 ")
    }

    func configure(placeholder: String, isPassword: Bool, allowIsSelected: Bool) {
        self.allowIsSelected = allowIsSelected
        self.isPassword = isPassword
        setMaskText(placeholder)
        numberOfCharactersLabel.isHidden = true
        numberOfCharactersLabelTrailingAnchor.constant = 0
        numberOfCharactersLabel.widthAnchor.constraint(equalToConstant: 0).isActive = true
        placeholderLabel.text = placeholder
        nameMaskView.isHidden = true
        maxNumberOfCharaters = 120
        textView.keyboardType = .emailAddress
        textView.tintColor = .lightGrey
        textView.textContentType = .emailAddress
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none

        if isPassword {
            textView.isSecureTextEntry = true
            textView.textContentType = .password
        }
        nameMaskViewWidthAnchor.constant = maskLabel.intrinsicContentSize.width + 15
        layoutIfNeeded()
    }

    func currentText() -> String? {
        return textView.text
    }

    // MARK: - Private methods

    private func setMaskText(_ string: String?) {
        maskLabel.setAttributedText(string, lineHeightMultiple: 0.73, kern: nil)
    }

    private func setupNumberOfCharacters(name: String) {
        numberOfCharactersLabel.textColor = .lightGrey

        let numberOfCharactersLabelText = NSMutableAttributedString(string: "\(name.count) / \(maxNumberOfCharaters.description)", attributes: [
            .foregroundColor: UIColor.lightGrey
        ])

        numberOfCharactersLabelText.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: name.count.description.count))
        numberOfCharactersLabel.attributedText = numberOfCharactersLabelText
    }

    private func setupViews() {
        textContainer.roundCorners(corners: .allCorners, radius: 16)
        textContainer.backgroundColor = .clear
        textContainer.borderColor = .lufelRed
        textContainer.borderWidth = 0.5

        addSubview(textContainer, withEdgeInsets: .zero)

        textContainer.addSubview(numberOfCharactersLabel, constraints: [
            numberOfCharactersLabel.centerYAnchor.constraint(equalTo: textContainer.centerYAnchor),
            numberOfCharactersLabelTrailingAnchor
        ])

        textView.backgroundColor = .clear
        textView.delegate = self

        textView.font = UIFont(name: "Manrope-Regular", size: 18)
        textView.textColor = UIColor.white

        textContainer.addSubview(textView, constraints: [
            textView.centerYAnchor.constraint(equalTo: textContainer.centerYAnchor),
            textView.leadingAnchor.constraint(equalTo: textContainer.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: textContainer.trailingAnchor, constant: -20),
            textView.heightAnchor.constraint(equalToConstant: 25)
        ])

        maskLabel.font = UIFont(name: "Manrope-Regular", size: 12)
        placeholderLabel.font = UIFont(name: "Manrope-Regular", size: 18)
        placeholderLabel.sizeToFit()

        textView.addSubview(placeholderLabel, constraints: [
            placeholderLabel.centerYAnchor.constraint(equalTo: textContainer.centerYAnchor),
            placeholderLabel.leadingAnchor.constraint(equalTo: textContainer.leadingAnchor, constant: 18),
            placeholderLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor),
            placeholderLabel.heightAnchor.constraint(equalToConstant: 25)
        ])

        if let text = textView.text {
            placeholderLabel.isHidden = !text.isEmpty
        }

        placeholderLabel.textColor = .lightGrey

        nameMaskView.addSubview(maskLabel, constraints: [
            maskLabel.topAnchor.constraint(equalTo: nameMaskView.topAnchor),
            maskLabel.bottomAnchor.constraint(equalTo: nameMaskView.bottomAnchor),
            maskLabel.leadingAnchor.constraint(equalTo: nameMaskView.leadingAnchor, constant: 6),
            maskLabel.trailingAnchor.constraint(equalTo: nameMaskView.trailingAnchor, constant: -6)
        ])

        maskLabel.textColor = .lightGrey
        maskLabel.textAlignment = .center
        nameMaskView.backgroundColor = .redTint

        addSubview(nameMaskView, constraints: [
            nameMaskView.topAnchor.constraint(equalTo: textContainer.topAnchor, constant: -6),
            nameMaskView.leadingAnchor.constraint(equalTo: textContainer.leadingAnchor, constant: 16),
            nameMaskView.heightAnchor.constraint(equalToConstant: 13),
            nameMaskViewWidthAnchor
        ])

        textView.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textView.addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)

    }

    @objc private func textFieldDidBeginEditing() {
        placeholderLabel.isHidden = true
        nameMaskView.isHidden = false
        textContainer.borderWidth = allowIsSelected ? 1 : 0.5
    }

    @objc private func textFieldDidChange() {
        if let text = textView.text {
            placeholderLabel.isHidden = !text.isEmpty
            nameMaskView.isHidden = text.isEmpty
            setupNumberOfCharacters(name: text)
            delegate?.didEditText(text, self)
        }
    }
}

// MARK: - Extensions

extension CustomPlaceholderTextView: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textView.text {
            placeholderLabel.isHidden = !text.isEmpty
            nameMaskView.isHidden = text.isEmpty
            textContainer.borderWidth = 0.5
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            if maxNumberOfCharaters == 15 {
                let currentText = textField.text ?? ""
                guard let stringRange = Range(range, in: currentText) else { return false }
                let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
                return updatedText.count <= maxNumberOfCharaters
            }

            if let allowedCharacterSet = allowedCharacterSet {
                let replacementStringIsValid = text.rangeOfCharacter(from: allowedCharacterSet.inverted) == nil

                return replacementStringIsValid
            }
        }
        return true
    }
}

protocol CustomPlaceholderTextViewDelegate: AnyObject {
    func didEditText(_ newText: String, _ uiView: UIView)
}

