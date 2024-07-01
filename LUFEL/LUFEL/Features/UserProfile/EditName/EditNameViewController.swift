//
//  EditNameViewController.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 01.07.2024.
//

import UIKit
import Combine

class EditNameViewController: UIViewController {

    // MARK: - Views

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var setNameView: CustomPlaceholderTextView!
    @IBOutlet weak var saveNameButton: UIButton!
    @IBOutlet weak var saveButtonBottomConstraint: NSLayoutConstraint!

    // MARK: - Properties

    weak var delegate: EditNameViewControllerDelegate?
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Services

    @Injected(\.userProvider) var userProvider: UserProviding

    // MARK: - Life

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        getUser()
        registerForKeyboardNotifications()
        setupTapGesture()
        setupPublisher()
    }

    // MARK: - Actions

    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func saveNameTapped(_ sender: Any) {
        guard let newName = setNameView.currentText() else { return }
        editName(name: newName)
        delegate?.didUpdateName(newName)
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Private Methods

    private func getUser() {
        Task { @MainActor in
            guard let user = await userProvider.getUser(), let name = user.displayName else { return }
            DispatchQueue.main.async { [weak self] in
                self?.setNameView.configure(type: .name, existingText: name, placeholder: "name", maxNumberOfCharaters: 15)
            }
        }
    }

    private func editName(name: String) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let finalName = trimmedName.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)

        guard !finalName.isEmpty else { return }

        Task { @MainActor in
            if let _ = await userProvider.setName(username: finalName) {
                delegate?.didUpdateName(finalName)
            }
        }
    }

    private func setupPublisher() {
        setNameView.textPublisher
            .sink { [weak self] newName in
                guard let newName = newName else { return }
                self?.editName(name: newName)
            }
            .store(in: &cancellables)
    }

    private func setupViews() {
        setNameView.delegate = self
        saveNameButton.alpha = 0.24
        saveNameButton.isUserInteractionEnabled = false
    }

    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }


    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            saveButtonBottomConstraint.constant = keyboardSize.height
            UIView.animate(withDuration: 0.25) { [weak self] in
                self?.view.layoutIfNeeded()
            }
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        saveButtonBottomConstraint.constant = 16
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Deinit

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension EditNameViewController: CustomPlaceholderTextViewDelegate {
    func didEditText(_ newText: String, _ uiView: UIView) {
        saveNameButton.alpha = 1
        saveNameButton.isUserInteractionEnabled = true
    }
}

protocol EditNameViewControllerDelegate: AnyObject {
    func didUpdateName(_ newName: String)
}
