//
//  TopThreeTableViewCell.swift
//  LMWNCoin
//
//  Created by kowit nanumchill on 31/3/2567 BE.
//

import UIKit

class TopThreeTableViewCell: UITableViewCell {

    func bind(_ viewModel: DashboardItemModel) {
        print("viewview \(viewModel.title)")
//        viewModel.topthreeCoins.drive(topthreeCollectionView.rx.items(cellIdentifier: TopThreeCollectionViewCell.reuseID, cellType: TopThreeCollectionViewCell.self)) { cv, viewModel, cell in
//                        cell.bind(viewModel)
//                    }.disposed(by: disposeBag)
    }
}
