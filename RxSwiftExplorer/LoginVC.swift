//
//  ViewController.swift
//  RxSwiftExplorer
//
//  Created by Anton Honcharov on 5/27/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class LoginVC: UIViewController {
  // MARK: - Properties
  let disposeBag = DisposeBag()
  let loginModel = LoginFormVM()
  var isPasswordTouched = false
  var isEmailTouched = false

  // MARK: - IBOutlets
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var emailErrorHint: UILabel!

  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var passwordErrorHint: UILabel!

  @IBOutlet weak var loginButton: UIButton!
}

// MARK: - Life cycle
extension LoginVC {
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    setupUI()
    setupBindings()
  }
}

// MARK: - Set up
extension LoginVC {
  func setupBindings() {
    emailTextField
      .rx
      .text
      .bind(to: loginModel.emailSubject)
      .disposed(by: disposeBag)

    emailTextField
      .rx
      .controlEvent([.editingDidEnd, .editingChanged])
      .asObservable()
      .subscribe(onNext: { [weak self] _ in
        guard let `self` = self,
              let isEmailValid = self.emailTextField.text?.validateEmail() else { return }

        self.emailErrorHint.isHidden = self.isEmailTouched && isEmailValid
      })
      .disposed(by: disposeBag)

    passwordTextField
      .rx
      .controlEvent(.editingChanged)
      .asObservable()
      .subscribe(onNext: { [weak self] _ in
        guard let `self` = self,
              let isPasswordValid = self.passwordTextField.text?.validatePassword() else { return }

        self.passwordErrorHint.isHidden = isPasswordValid
      })
      .disposed(by: disposeBag)

    passwordTextField
      .rx
      .text
      .bind(to: loginModel.passwordSubject)
      .disposed(by: disposeBag)

    loginModel
      .isValidForm
      .bind(to: loginButton.rx.valid)
      .disposed(by: disposeBag)

  }
  func setupUI() {
    emailTextField.keyboardType = .emailAddress
    emailTextField.autocapitalizationType = .none
    emailTextField.autocorrectionType = .no

    passwordTextField.keyboardType = .twitter
    passwordTextField.autocapitalizationType = .none
    passwordTextField.autocorrectionType = .no
    passwordTextField.isSecureTextEntry = true

    emailErrorHint.isHidden = true
    passwordErrorHint.isHidden = true

    loginButton.isEnabled = false
    loginButton.alpha = 0.5

    setupPasswordIcon()
  }

  func setupPasswordIcon() {
    if let passwordIcon = UIImage(systemName: "eye"), let passwordIconSlash = UIImage(systemName: "eye.slash") {
      let imageView = UIImageView(frame: CGRect(x: 15, y: 13, width: 20, height: 15))
      passwordTextField.tintColor = .lightGray
      imageView.image = passwordIcon
      imageView
        .rx
        .tapGesture()
        .when(.recognized)
        .subscribe(onNext: { [weak self] tap in
          guard let `self` = self else { return }
          self.passwordTextField.isSecureTextEntry = !self.passwordTextField.isSecureTextEntry
          imageView.image = imageView.image != passwordIcon ?  passwordIcon : passwordIconSlash
        })
        .disposed(by: disposeBag)

      let imageContainerView = UIView(frame: CGRect(x: 0,
                                                    y: 0,
                                                    width: CGFloat(passwordTextField.frame.width / 7),
                                                    height: passwordTextField.frame.height))
      imageContainerView.addSubview(imageView)
      passwordTextField.rightView = imageContainerView
      passwordTextField.rightViewMode = .always
    }
  }
}

// MARK: - IBActions
// MARK: - Navigation
// MARK: - Network Manager calls
// MARK: - Extensions
