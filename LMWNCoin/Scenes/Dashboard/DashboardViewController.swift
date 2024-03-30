import UIKit
import RxSwift
import RxCocoa

class DashboardViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    var viewModel: DashboardViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadmoreView: UIView!
    @IBOutlet weak var tryAgainView: UIView!
    @IBOutlet weak var tryAgain: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        bindViewModel()
    }
    
    private func configureTableView() {
        tableView.refreshControl = UIRefreshControl()
        tableView.estimatedRowHeight = 102
        tableView.rowHeight = UITableView.automaticDimension
        loadmoreView.isHidden = true
        tryAgainView.isHidden = true
    }
    
    private func bindViewModel() {
        assert(viewModel != nil)
        
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        let pull = tableView.refreshControl!.rx
            .controlEvent(.valueChanged)
            .asDriver()
        
        let loadMore = tableView.rx.contentOffset
            .asDriver()
            .throttle(.seconds(3))
            .flatMap { [weak self] contentOffset -> Driver<Void> in
                guard let self = self else { return .empty() }
                let tableViewHeight = self.tableView.frame.height
                let contentHeight = self.tableView.contentSize.height
                let offsetY = contentOffset.y
                let bottomOffset = contentHeight - tableViewHeight
                if offsetY > 0 && offsetY >= bottomOffset - 100 {
                    return .just(())
                } else {
                    return .empty()
                }
            }
        
        let refreshTrigger = Driver<Void>.merge(
            viewWillAppear,
            pull,
            tryAgain.rx.tap.asDriver()
        )
        
        let input = DashboardViewModel.Input(trigger: refreshTrigger, loadMore: loadMore, selection: tableView.rx.itemSelected.asDriver())
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
        
        output.error
            .drive(onNext: { [weak self] _ in
                self?.tryAgainView.isHidden = false
                self?.loadmoreView.isHidden = true
            })
            .disposed(by: disposeBag)
        
        output.loadingMore
            .drive(onNext: { [weak self] isLoadingMore in
                self?.loadmoreView.isHidden = !isLoadingMore
            })
            .disposed(by: disposeBag)
        
        output.refresh
            .drive(onNext: { [weak self] refresh in
                if refresh {
                    self?.loadmoreView.isHidden = true
                    self?.tryAgainView.isHidden = true
                    self?.tableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
    }
}
