//
//  DetailViewController.swift
//  DesafioModal
//
//  Created by RICARDO AGNELO DE OLIVEIRA on 09/12/21.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var repoView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 235 / 255, green: 236 / 255, blue: 238 / 255, alpha: 1.0)
        roundTop(viewName: repoView)
    }

// da certo ae o porra
}
