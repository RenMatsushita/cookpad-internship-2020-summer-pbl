//
//  SelectedFoodstuffCollectionViewDataSource.swift
//  cookpad-internship-2020-summer-pbl
//
//  Created by Ren Matsushita on 2020/08/28.
//  Copyright © 2020 Ren Matsushita. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class SelectedFoodstuffCollectionViewDataSource: NSObject, RxCollectionViewDataSourceType, UICollectionViewDataSource {
    typealias Element = [Foodstuff]
    private var items: Element = []
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        Console.log(items[indexPath.row])
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectedFoodstuffCell", for: indexPath)
        cell.backgroundColor = .white
        let foodstuffImageView = UIImageView(frame: cell.contentView.frame)
        foodstuffImageView.layer.cornerRadius = 8
        foodstuffImageView.clipsToBounds = true
        foodstuffImageView.image = UIImage(named: items[indexPath.row].imageName)
        foodstuffImageView.contentMode = .scaleAspectFill
        cell.contentView.addSubview(foodstuffImageView)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, observedEvent: Event<[Foodstuff]>) {
        Binder<Element>(self) { dataSource, element in
            dataSource.items = element
            collectionView.reloadData()
        }.on(observedEvent)
    }
}
