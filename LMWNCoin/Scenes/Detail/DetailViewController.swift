
import UseCases
import RxSwift
import RxCocoa
import SDWebImage

class DetailViewController: UIViewController {
    
    var viewModel: DetailViewModel!
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImgage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var marketCapLabel: UILabel!
    @IBOutlet weak var titleValueLabel: UILabel!
    @IBOutlet weak var priceValueLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var gotoWebsiteButton: UIButton!
    @IBOutlet weak var marletCapValueLabel: UILabel!
    
    let disposBag = DisposeBag()
    var subtitleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindElements()
    }
    
    private func setupViews() {
        
    }
    
    private func bindElements() {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        let input = DetailViewModel.Input(trigger: viewWillAppear)
        let output = viewModel.transform(input: input)
        
        output.dashboardItem.drive(cityBinding)
            .disposed(by: disposBag)
    }
    
    var cityBinding: Binder<DashboardItemModel> {
        return Binder(self, binding: { (_ , coin) in
            self.setupDetailViewBy(coin: coin.coin)
        })
    }
    
    private func setupDetailViewBy(coin: Coins?) {
        titleLabel.text = coin?.name ?? "N/A"
        titleValueLabel.text = coin?.symbol ?? ""
        priceLabel.text = "PRICE"
        priceValueLabel.setFormattedCurrency(fromString: coin?.price ?? "", currencySymbol: "$", maximumFractionDigits: 5)
        marketCapLabel.text = "MARKET CAP"
        marletCapValueLabel.setTrillionFormattedText(from: coin?.marketCap ?? "", currencySymbol: "$")
        detailTextView.text = coin?.name ?? "N?A"
        
        iconImgage.sd_setImage(with: URL(string: coin?.iconUrl ?? ""), placeholderImage: UIImage(named: "img_placeholder"))
        
        closeButton.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        gotoWebsiteButton.rx.tap
            .bind { [weak self] in
                guard let _ = self else { return }
                if let url = URL(string: coin?.coinrankingUrl ?? "") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            .disposed(by: disposeBag)
    }
}
