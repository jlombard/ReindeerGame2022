//
//  UIViewExtension.swift
//  RealityShutter
//
//  Created by Sergen Gönenç on 23/12/2022.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        
        get {
            return layer.cornerRadius
        }
    }
}
