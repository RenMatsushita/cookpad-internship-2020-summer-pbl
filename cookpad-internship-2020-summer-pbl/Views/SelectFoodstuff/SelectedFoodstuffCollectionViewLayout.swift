//
//  SelectedFoodstuffCollectionViewLayout.swift
//  cookpad-internship-2020-summer-pbl
//
//  Created by Ren Matsushita on 2020/08/28.
//  Copyright © 2020 Ren Matsushita. All rights reserved.
//

import UIKit

struct SelectedFoodstuffCollectionViewLayout {
    static func create() -> UICollectionViewLayout {
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalHeight(1),
            heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 24, bottom: 10, trailing: 0)
        section.interGroupSpacing = 10
        let layoutConfiguration: UICollectionViewCompositionalLayoutConfiguration = .init()
        layoutConfiguration.scrollDirection = .horizontal
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.configuration = layoutConfiguration
        return layout
    }
}
