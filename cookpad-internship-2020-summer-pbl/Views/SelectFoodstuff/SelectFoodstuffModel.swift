//
//  FoodstuffModel.swift
//  cookpad-internship-2020-summer-pbl
//
//  Created by Ren Matsushita on 2020/08/27.
//  Copyright © 2020 Ren Matsushita. All rights reserved.
//

import RxSwift

protocol FoodstuffModelProtocol {
    func getFoodstuffChoises() -> Observable<[Foodstuff]>
}

final class FoodstuffModel: FoodstuffModelProtocol {
    func getFoodstuffChoises() -> Observable<[Foodstuff]> {
        return Observable.of([[
            Foodstuff(name: "waiwai", imageName: "takoyaki", gramWeight: "", mineral: 0, vitamin: 0, lipid: 0, sugariness: 0, protein: 0, genre: .vegetable),
            Foodstuff(name: "ssssss", imageName: "takoyaki", gramWeight: "", mineral: 0, vitamin: 0, lipid: 0, sugariness: 0, protein: 0, genre: .vegetable),
            Foodstuff(name: "waiwai", imageName: "takoyaki", gramWeight: "", mineral: 0, vitamin: 0, lipid: 0, sugariness: 0, protein: 0, genre: .vegetable)
        ], [
            Foodstuff(name: "waiwai", imageName: "takoyaki", gramWeight: "", mineral: 0, vitamin: 0, lipid: 0, sugariness: 0, protein: 0, genre: .vegetable),
            Foodstuff(name: "ssssss", imageName: "takoyaki", gramWeight: "", mineral: 0, vitamin: 0, lipid: 0, sugariness: 0, protein: 0, genre: .vegetable),
            Foodstuff(name: "sss", imageName: "takoyaki", gramWeight: "", mineral: 0, vitamin: 0, lipid: 0, sugariness: 0, protein: 0, genre: .vegetable)
            ]].randomElement()!)
    }
}

