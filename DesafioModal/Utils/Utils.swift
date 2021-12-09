//
//  Utils.swift
//  DesafioModal
//
//  Created by RICARDO AGNELO DE OLIVEIRA on 08/12/21.
//

import Foundation
import UIKit

func roundCorners(numbersOfFilters: UILabel!) {
    numbersOfFilters?.layer.masksToBounds = true
    numbersOfFilters.layer.cornerRadius = 8
}

func bottomBlackline(viewName: UIView!) {
    let bottomLine = CALayer()
    bottomLine.frame = CGRect(x: 0, y: viewName.frame.height - 3, width: viewName.frame.width, height: 3)
    bottomLine.backgroundColor = UIColor.black.cgColor
    viewName.layer.addSublayer(bottomLine)
}

func roundTop(viewName: UIView!) {
    viewName.clipsToBounds = true
    viewName.layer.cornerRadius = 10
    viewName.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
}
