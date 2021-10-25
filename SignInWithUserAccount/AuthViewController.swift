//
//  AuthViewController.swift
//  SignInWithUserAccount
//
//  Created by haanwave on 2021/10/25.
//

import UIKit

class AuthViewController: UIViewController {
    @IBOutlet weak var idInputField: UITextField!
    @IBOutlet weak var passwordInputField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    var isTest = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.isEnabled = false
        configureInputField()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(adjustInputView(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(adjustInputView(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    private func configureInputField() {
        [idInputField, passwordInputField].forEach {
            $0?.addTarget(self,
                          action: #selector(inputFieldDidChanged(_:)),
                          for: .editingChanged)
        }
    }
    
    @objc private func inputFieldDidChanged(_ textField: UITextField) {
        validateInputField()
    }
    
    private func validateInputField() {
        signInButton.isEnabled = !(idInputField.text?.isEmpty ?? true) && !(passwordInputField.text?.isEmpty ?? true)
    }
    
    @IBAction func tapSignInButton(_ sender: UIButton) {
        isTest ? showAlert(message: "로그인 성공") : signIn()
    }
    
    private func signIn() {
        guard let id = idInputField.text else { return }
        guard let password = idInputField.text else { return }
        SignInAPI.signIn(id: id, password: password) { accessToken, error in
            guard error == nil else {
                self.showAlert(message: "로그인에 실패했습니다.")
                return
            }
            /// do something with accessToken...
            self.showAlert(message: "로그인 성공")
        }
    }
    
    @objc private func adjustInputView(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        if notification.name == UIResponder.keyboardWillShowNotification {
            view.frame.origin.y = -(keyboardFrame.height / 2)
        }
        else {
            view.frame.origin.y = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func showAlert(message: String?) {
        let ac = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default)
        ac.addAction(confirm)
        present(ac, animated: true)
    }
}
