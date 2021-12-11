//
//  RepositoryTableViewCell.swift
//  DesafioModal
//
//  Created by MARCOS FELIPE SOARES ROCHA on 07/12/21.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {
    @IBOutlet var name: UILabel!
    @IBOutlet var owner: UILabel!
    @IBOutlet var starsLabel: UILabel!
    @IBOutlet var starsNumber: UILabel!

    @IBOutlet var watchersNumber: UILabel!
    @IBOutlet var forksNumber: UILabel!
    @IBOutlet var daysAgo: UILabel!

    @IBOutlet var topRectangle: UIView!
    @IBOutlet var bottomRectangle: UIView!

    @IBOutlet var profilePicture: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor(red: 235 / 255, green: 236 / 255, blue: 238 / 255, alpha: 1.0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 8, bottom: 16, right: 8))
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func invertTheme() {
        self.owner.textColor = .black
        self.name.textColor = .black
        self.starsLabel.textColor = .black
        self.starsNumber.textColor = .black
        self.topRectangle.backgroundColor = .white
        self.bottomRectangle.backgroundColor = .gray
    }

    func mainTheme() {
        self.owner.textColor = .white
        self.name.textColor = .white
        self.starsLabel.textColor = .white
        self.starsNumber.textColor = .white
        self.topRectangle.backgroundColor = UIColor(red: 0.14, green: 0.14, blue: 0.16, alpha: 1.0)
        self.bottomRectangle.backgroundColor = .black
    }

    func setData(repository: Repository) {
        self.owner.text = repository.fullName
        self.name.text = repository.name

        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale(identifier: "pt_BR")

        self.starsNumber.text = numberFormatter.string(from: NSNumber(value: repository.stargazersCount))
        self.watchersNumber.text = numberFormatter.string(from: NSNumber(value: repository.watchersCount))
        self.forksNumber.text = numberFormatter.string(from: NSNumber(value: repository.forksCount))
        self.daysAgo.text = "\(numberFormatter.string(from: NSNumber(value: formatDate(date: repository.updatedAt)))!) dias"

        let data = try? Data(contentsOf: URL(string: "https://github.com/\(repository.owner).png")!)
        self.profilePicture.image = UIImage(data: data!)
    }

    func formatDate(date: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: date)!
        let days = Calendar.current.dateComponents([.day], from: date, to: Date())
        return days.day!
    }

}
