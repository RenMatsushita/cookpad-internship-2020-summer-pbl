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
    let deleteButtonTapSubject: PublishSubject<Foodstuff> = .init()
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectedFoodstuffCell", for: indexPath) as! FoodstuffImageCollectionViewCell
        cell.configure(with: items[indexPath.item])
        cell.deleteButtonTapped
            .subscribe(onNext: { [weak self] foodstuff in
                self?.deleteButtonTapSubject.onNext(foodstuff)
            })
            .disposed(by: cell.disposeBag)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, observedEvent: Event<[Foodstuff]>) {
        Binder<Element>(self) { dataSource, element in
            dataSource.items = element
            collectionView.reloadData()
        }.on(observedEvent)
    }
}
