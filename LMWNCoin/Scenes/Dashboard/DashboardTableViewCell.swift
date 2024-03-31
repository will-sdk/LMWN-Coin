//
//  DashboardTableViewCell.swift
//  LMWNCoin
//
//  Created by kowit nanumchill on 28/3/2567 BE.
//

import UIKit
import SDWebImage

class DashboardTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var upScaleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    func bind(_ viewModel: DashboardItemModel) {
        self.titleLabel.text = viewModel.title
        self.detailsLabel.text = viewModel.subtitle
        self.priceLabel.text = viewModel.coin?.price
        self.upScaleLabel.text = viewModel.change
        self.iconImageView.sd_setImage(with: viewModel.thumbnail, placeholderImage: UIImage(named: "img_placeholder"))
    }

}
