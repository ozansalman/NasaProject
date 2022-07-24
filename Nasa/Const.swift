//
//  Const.swift
//  Nasa
//
//  Created by Ozan Salman on 24.07.2022.
//

import Foundation
import UIKit

class Const: UIView {
    func viewMainCustomWithShadow(view: UIView){
        view.layer.cornerRadius = 25.0
        view.layer.masksToBounds = false
        view.layer.shadowRadius = 4
        view.layer.shadowOffset = .zero
        view.layer.shadowOpacity = 0.1
        view.layer.rasterizationScale = UIScreen.main.scale
    }
    
    struct singlePicker {
        static var selectValue: singlePicker = singlePicker()
        var selectedValue: String = ""
    }
}
