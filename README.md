# Sign In With UserAccount
Sign In using the registered user ID and password.

## Settings

#### 1. Validate InputField.
If you do not enter your ID and password, you cannot sign in. Check if the input field value is entered using validate.

```swift
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
```

#### 2. Adjust The Input View When Keyboard Is Visible & Disappears.
```swift
override func viewDidLoad() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(adjustInputView(_:)),
                                           name: UIResponder.keyboardWillShowNotification,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(adjustInputView(_:)),
                                           name: UIResponder.keyboardWillHideNotification,
                                           object: nil)
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
```

## API
Sign In API using Alamofire. Send ID and password through HTTPHeaders and receive accessToken from response header.

```swift
import Foundation
import Alamofire

struct SignInAPI {
    static func signIn(id: String, password: String, completion: @escaping (String?, Error?) -> Void) {
        let url = "https://api.sample.com/account"
        let parameters: Parameters = ["id": id, "password": password]
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let accessToken = response.response?.headers["accessToken"] {
                        completion(accessToken, nil)
                        print("--->[SignInAPI:signIn] Sign In Success")
                    }
                case .failure(let error):
                    print("--->[SignInAPI:signIn] ERROR:", error)
                    completion(nil, error)
                }
            }
    }
}
```

#### Example
```swift
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
```
