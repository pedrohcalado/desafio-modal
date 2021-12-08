//
//  RepositoriesViewController.swift
//  DesafioModal
//
//  Created by RICARDO AGNELO DE OLIVEIRA on 08/12/21.
//

import UIKit

class RepositoriesViewController: UIViewController {
    @IBOutlet var numbersOfFilters: UILabel!
    
    @IBOutlet var filterNames: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        InitialConfig(numbersOfFilters: numbersOfFilters, filterNames: filterNames)

    }

}
