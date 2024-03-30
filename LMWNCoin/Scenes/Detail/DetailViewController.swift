
import UseCases
import RxSwift
import RxCocoa

class DetailViewController: UIViewController {
    
    var viewModel: DetailViewModel!
    
    @IBOutlet weak var titleLabel: UILabel!
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
    
    var cityBinding: Binder<DashboardItemViewModel> {
        return Binder(self, binding: { (_ , city) in
            self.setupMapViewBy(coin: city.coin)
        })
    }
    
    private func setupMapViewBy(coin: Coins?) {
        // Set map region and add a pin
        titleLabel.text = coin?.name ?? "N/A"
    }
    
}
