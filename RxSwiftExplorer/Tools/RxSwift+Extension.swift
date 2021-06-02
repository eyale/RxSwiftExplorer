//
//  RxSwift+Extension.swift
//  RxSwiftExplorer
//
//  Created by Anton Honcharov on 6/1/21.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base : UIButton {
  public var valid : Binder<Bool> {
    return Binder(self.base) { button, valid in
      button.isEnabled = valid
      UIView.animate(withDuration: 0.3) {
        button.alpha = valid ? 1.0 : 0.5
      }
    }
  }
}
