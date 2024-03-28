//
//  DashboardTableViewCell.swift
//  LMWNCoin
//
//  Created by kowit nanumchill on 28/3/2567 BE.
//

import UIKit

class DashboardTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    func bind(_ viewModel: DashboardItemViewModel) {
        self.titleLabel.text = viewModel.title
        self.detailsLabel.text = viewModel.subtitle
    }

}
