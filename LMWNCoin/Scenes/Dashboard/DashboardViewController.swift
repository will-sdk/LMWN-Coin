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
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var topthreeCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureCollectionView()
        bindViewModel()
    }
    
    private func configureTableView() {
        tableView.refreshControl = UIRefreshControl()
        tableView.estimatedRowHeight = 102
        tableView.rowHeight = UITableView.automaticDimension
        loadmoreView.isHidden = true
        tryAgainView.isHidden = true
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 110, height: 140)
        topthreeCollectionView.collectionViewLayout = layout
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
                if offsetY > 0 && offsetY >= bottomOffset - 600 {
                    return .just(())
                } else {
                    return .empty()
                }
            }
        
        let searchInput = searchBar.rx.text.orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .asDriverOnErrorJustComplete()
        
        let viewWillAppearString = viewWillAppear.map { "" }
        let pullString = pull.map { "" }
        let tryAgainString = tryAgain.rx.tap.asDriver().map { "" }
        
        let refreshTrigger = Driver<String>.merge(
            viewWillAppearString,
            pullString,
            tryAgainString,
            searchInput
        )
        
        let input = DashboardViewModel.Input(trigger: refreshTrigger, loadMore: loadMore, selection: tableView.rx.itemSelected.asDriver())
        let output = viewModel.transform(input: input)
        
        output.coins.drive(tableView.rx.items(cellIdentifier: DashboardTableViewCell.reuseID, cellType: DashboardTableViewCell.self)) { tv, viewModel, cell in
            cell.bind(viewModel)
        }.disposed(by: disposeBag)
        
        output.topthreeCoins.drive(topthreeCollectionView.rx.items(cellIdentifier: TopThreeCollectionViewCell.reuseID, cellType: TopThreeCollectionViewCell.self)) { cv, viewModel, cell in
                cell.bind(viewModel)
            }.disposed(by: disposeBag)
        
        output.topthreeCoins
                .map { $0.isEmpty }
                .drive(onNext: { [weak self] isEmpty in
                    guard let self = self else { return }
                    topthreeCollectionView.frame.size.height = isEmpty ? 0 : 140
                    self.view.layoutIfNeeded()
                })
                .disposed(by: disposeBag)
        output.fetching
            .drive(tableView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        output.selectedCoin
            .drive()
            .disposed(by: disposeBag)
        
        output.error
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.tryAgainView.isHidden = false
                self.loadmoreView.isHidden = true
            })
            .disposed(by: disposeBag)
        
        output.loadingMore
            .drive(onNext: { [weak self] isLoadingMore in
                self?.loadmoreView.isHidden = !isLoadingMore
            })
            .disposed(by: disposeBag)
        
        output.refresh
            .drive(onNext: { [weak self] refresh in
                guard let self = self else { return }
                if refresh.isEmpty {
                    self.loadmoreView.isHidden = true
                    self.tryAgainView.isHidden = true
                    self.searchBar.text = ""
                    self.searchBar.resignFirstResponder()
                    self.tableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
    }
}

extension DashboardViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchBar.resignFirstResponder()
        }
    }
}
