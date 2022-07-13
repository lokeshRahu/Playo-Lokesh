//
//  NewsTableViewCell.swift
//  Playo
//
//  Created by yeshwanth srinivas rao bandaru on 13/07/22.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var newsImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
      
        newsImage.contentMode = .scaleAspectFill
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
