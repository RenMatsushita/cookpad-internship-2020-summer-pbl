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
    private let selectedFoodStuffs: BehaviorRelay<[Foodstuff]> = .init(value: [])
    
    private let disposeBag: DisposeBag = .init()
    init(model: FoodstuffModelProtocol = FoodstuffModel()) {
        foodstuffChoises = refreshSubject
            .flatMap { _ -> Observable<[Foodstuff]> in
                return model.getFoodstuffChoises()
            }
    }
}
