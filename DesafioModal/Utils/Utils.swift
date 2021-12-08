//
//  Utils.swift
//  DesafioModal
//
//  Created by RICARDO AGNELO DE OLIVEIRA on 08/12/21.
//

import Foundation
import UIKit

func initialConfig (numbersOfFilters: UILabel!, filterNames: UIView!) {
    numbersOfFilters?.layer.masksToBounds = true
    numbersOfFilters.layer.cornerRadius = 8
    filterNames.clipsToBounds = true
    filterNames.layer.cornerRadius = 10
    filterNames.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    let bottomLine = CALayer()
    bottomLine.frame = CGRect(x: 0, y: filterNames.frame.height - 3, width: filterNames.frame.width, height: 3)
    bottomLine.backgroundColor = UIColor.black.cgColor
    filterNames.layer.addSublayer(bottomLine)
}
