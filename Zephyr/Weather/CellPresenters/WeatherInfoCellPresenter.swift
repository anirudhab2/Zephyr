//
//  WeatherInfoCellPresenter.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 17/09/23.
//

import UIKit

protocol WeatherInfoCellPresenter {
    func cellIdentifier() -> String
    func configure(cell: UICollectionViewCell)
}
