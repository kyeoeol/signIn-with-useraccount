## Sign In With User Account
Sign In using the registered user ID and password.

## Settings

#### 1. validate InputField
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
