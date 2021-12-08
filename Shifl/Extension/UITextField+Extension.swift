//
//  UITextField+Extension.swift
//  Shifl
//
//  Created by Mohammad Sulthan on 08/12/21.
//

import Foundation
import UIKit

extension UITextField {
    func setIcon(_ image: UIImage) {
        self.rightViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 20))
        imageView.image = image
        imageView.tintColor = UIColor(named: "text_color_black")
        self.rightView = imageView
    }
}
