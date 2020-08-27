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
    
    private let disposeBag: DisposeBag = .init()
    init(model: FoodstuffModelProtocol = FoodstuffModel()) {
        foodstuffChoises = refreshSubject
            .flatMap { _ -> Observable<[Foodstuff]> in
                return model.getFoodstuffChoises()
            }
        
        radarChartDataSet = selectedFoodStuffsRelay
            .map { foodstuff in
                let radarChartDataSet = RadarChartDataSet(entries: [
                    RadarChartDataEntry(value: 210),
                    RadarChartDataEntry(value: 60.0),
                    RadarChartDataEntry(value: 150.0),
                    RadarChartDataEntry(value: 150.0),
                    RadarChartDataEntry(value: 160.0),
                ])
//                radarChartDataSet.fillcolo
//                radarChartDataSet
                radarChartDataSet.label = nil
                return radarChartDataSet
            }
        
        selectFoodstuffSubject
            .subscribe(onNext: { [weak self] foodstuff in
                self?.selectedFoodStuffsRelay.accept(self?.selectedFoodStuffsRelay.value ?? [] + [foodstuff])
            })
            .disposed(by: disposeBag)
        
        cancelSelectFoodstuffSubject
            .subscribe(onNext: { [weak self] deleteFoodstuff in
                var selectedFoodstuffsValue = self?.selectedFoodStuffsRelay.value
                self?.selectedFoodStuffsRelay.accept(selectedFoodstuffsValue?.remove(value: deleteFoodstuff) ?? [])
            })
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
