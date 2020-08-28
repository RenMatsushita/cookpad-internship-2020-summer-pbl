//
//  SelectFoodstuffViewModel.swift
//  cookpad-internship-2020-summer-pbl
//
//  Created by Ren Matsushita on 2020/08/26.
//  Copyright © 2020 Ren Matsushita. All rights reserved.
//

import Charts
import RxSwift
import RxCocoa
import Foundation

final class SelectFoodstuffViewModel {
    // input
    let selectFoodstuffSubject: PublishSubject<Foodstuff> = .init()
    let cancelSelectFoodstuffSubject: PublishSubject<Foodstuff> = .init()
    let refreshSubject: PublishSubject<Void> = .init()
    
    //outputs
    var foodstuffChoises: Observable<[Foodstuff]>
    private let selectedFoodStuffsRelay: BehaviorRelay<[Foodstuff]> = .init(value: [])
    var selectedFoodStuffs: Observable<[Foodstuff]> {
        return selectedFoodStuffsRelay.asObservable()
    }
    var radarChartDataSet: Observable<RadarChartDataSet>
    let showSafariViewControllerSubject: PublishSubject<URL> = .init()
    
    private let disposeBag: DisposeBag = .init()
    init(searchButtonTapped: Observable<Void>,
        model: FoodstuffModelProtocol = FoodstuffModel()) {
        foodstuffChoises = refreshSubject
            .flatMap { _ -> Observable<[Foodstuff]> in
                return model.getFoodstuffChoises()
            }
        
        radarChartDataSet = selectedFoodStuffsRelay
            .map { foodstuffs in
                let nutorientBalance = model.calculateNutorientBalance(selected: foodstuffs)
                let radarChartDataSet = RadarChartDataSet(entries: [
                    RadarChartDataEntry(value: nutorientBalance.lipid),
                    RadarChartDataEntry(value: nutorientBalance.sugariness),
                    RadarChartDataEntry(value: nutorientBalance.protein),
                    RadarChartDataEntry(value: nutorientBalance.vitamin),
                    RadarChartDataEntry(value: nutorientBalance.mineral),
                ])
                radarChartDataSet.label = nil
                return radarChartDataSet
            }
        
        selectFoodstuffSubject
            .subscribe(onNext: { [weak self] foodstuff in
                var newValue = self!.selectedFoodStuffsRelay.value
                newValue.append(foodstuff)
                self?.selectedFoodStuffsRelay.accept(newValue)
            })
            .disposed(by: disposeBag)
        
        cancelSelectFoodstuffSubject
            .subscribe(onNext: { [weak self] deleteFoodstuff in
                var selectedFoodstuffsValue = self?.selectedFoodStuffsRelay.value
                self?.selectedFoodStuffsRelay.accept(selectedFoodstuffsValue?.remove(value: deleteFoodstuff) ?? [])
            })
            .disposed(by: disposeBag)
        
        searchButtonTapped
            .subscribe { _ in
                let searchQuery = self.selectedFoodStuffsRelay.value.map { $0.name }.joined(separator: " ")
                let urlString = "https://cookpad.com/search/\(searchQuery)"
                let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
                self.showSafariViewControllerSubject.onNext(url)
            }
            .disposed(by: disposeBag)
    }
}

extension Array where Element: Equatable {
    mutating func remove(value: Element) -> Array<Element> {
        if let i = self.firstIndex(of: value) {
            self.remove(at: i)
            return self
        }
        return []
    }
}
