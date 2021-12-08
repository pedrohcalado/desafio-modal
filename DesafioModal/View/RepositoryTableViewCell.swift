//
//  RepositoryTableViewCell.swift
//  DesafioModal
//
//  Created by MARCOS FELIPE SOARES ROCHA on 07/12/21.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {
    @IBOutlet var name: UILabel!
    @IBOutlet var starsLabel: UILabel!
    @IBOutlet var starsNumber: UILabel!
    @IBOutlet var topRectangle: UIView!
    @IBOutlet var bottomRectangle: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func invertTheme() {
        self.name.textColor = .black
        self.starsLabel.textColor = .black
        self.starsNumber.textColor = .black
        self.topRectangle.backgroundColor = .white
        self.bottomRectangle.backgroundColor = .gray
    }

}
