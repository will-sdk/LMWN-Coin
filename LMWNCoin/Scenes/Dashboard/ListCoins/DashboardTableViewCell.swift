
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
        self.upScaleLabel.text = viewModel.change
        self.iconImageView.sd_setImage(with: viewModel.thumbnail, placeholderImage: UIImage(named: "img_placeholder"))
        self.upScaleLabel.textColor = viewModel.isUpScale ? UIColor(hexString: "#13BC24") : UIColor(hexString: "#F82D2D")
        self.priceLabel.setFormattedCurrency(fromString: viewModel.coin?.price ?? "", currencySymbol: "$", maximumFractionDigits: 5)

    }

}
