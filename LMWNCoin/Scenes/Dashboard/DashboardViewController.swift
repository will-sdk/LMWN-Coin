
import UIKit
import RxSwift
import RxCocoa

class DashboardViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    var viewModel: DashboardViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        bindViewModel()
    }
    
    private func configureTableView() {
        tableView.refreshControl = UIRefreshControl()
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func bindViewModel() {
        assert(viewModel != nil)
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        let pull = tableView.refreshControl!.rx
            .controlEvent(.valueChanged)
            .asDriver()
        
        let input = DashboardViewModel.Input(trigger: Driver.merge(viewWillAppear, pull), selection: tableView.rx.itemSelected.asDriver())
        let output = viewModel.transform(input: input)
        
        output.coins.drive(tableView.rx.items(cellIdentifier: DashboardTableViewCell.reuseID, cellType: DashboardTableViewCell.self)) { tv, viewModel, cell in
            cell.bind(viewModel)
        }.disposed(by: disposeBag)
        
        output.fetching
            .drive(tableView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)

        output.selectedCoin
            .drive()
            .disposed(by: disposeBag)
    }

}
