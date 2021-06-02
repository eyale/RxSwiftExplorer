//
//  LoginFormVM.swift
//  RxSwiftExplorer
//
//  Created by Anton Honcharov on 6/1/21.
//

import Foundation
import RxSwift
import RxCocoa

class LoginFormVM {
  let disposeBag = DisposeBag()

  let emailSubject = BehaviorRelay<String?>(value: "")
  let passwordSubject = BehaviorRelay<String?>(value: "")

  var isValidForm: Observable<Bool> {
    return Observable
      .combineLatest(emailSubject, passwordSubject) { email, password in
        guard let emailVal = email, let passwordVal = password else { return false }

        return emailVal.validateEmail() && passwordVal.validatePassword()
      }
  }
}
