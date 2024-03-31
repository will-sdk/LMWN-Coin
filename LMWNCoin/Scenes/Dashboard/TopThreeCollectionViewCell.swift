
import UIKit

class TopThreeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var upScaleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    func bind(_ viewModel: DashboardItemModel) {
        self.titleLabel.text = viewModel.title
        self.detailsLabel.text = viewModel.subtitle
        self.upScaleLabel.text = viewModel.change
        self.iconImageView.sd_setImage(with: viewModel.thumbnail, placeholderImage: UIImage(named: "img_placeholder"))
    }
}
