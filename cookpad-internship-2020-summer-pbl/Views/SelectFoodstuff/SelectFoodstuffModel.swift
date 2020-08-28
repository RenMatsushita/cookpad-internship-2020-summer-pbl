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
    func calculateNutorientBalance(selected foodstuffs: [Foodstuff]) -> Nutorient
}

final class FoodstuffModel: FoodstuffModelProtocol {
    let foodstuffsMaterials = [
        Foodstuff(name: "じゃがいも", imageName: "poteto", gramWeight: 100, nutorient: Nutorient(mineral: 2, vitamin: 15, lipid: 0.1, sugariness: 20, protein: 1.5), genre: .vegetable),
        Foodstuff(name: "ニンジン", imageName: "ninjin", gramWeight: 100, nutorient: Nutorient(mineral: 32, vitamin: 4, lipid: 0.3, sugariness: 8.4, protein: 0.6), genre: .vegetable),
        Foodstuff(name: "オクラ", imageName: "okura", gramWeight: 100, nutorient: Nutorient(mineral: 90, vitamin: 7, lipid: 0.1, sugariness: 7.6, protein: 2.1), genre: .vegetable),
        Foodstuff(name: "クロマグロ", imageName: "utna", gramWeight: 100, nutorient: Nutorient(mineral: 5, vitamin: 2, lipid: 1.4, sugariness: 0.1, protein: 26.4), genre: .fish),
        Foodstuff(name: "タイ", imageName: "tai", gramWeight: 100, nutorient: Nutorient(mineral: 11, vitamin: 1, lipid: 5.8, sugariness: 0.1, protein: 20), genre: .fish),
        Foodstuff(name: "ハマチ", imageName: "hamachi", gramWeight: 100, nutorient: Nutorient(mineral: 19, vitamin: 2, lipid: 17.2, sugariness: 0.3, protein: 20.7), genre: .fish),
        Foodstuff(name: "鶏肉", imageName: "chicken", gramWeight: 100, nutorient: Nutorient(mineral: 6, vitamin: 2, lipid: 13.9, sugariness: 0, protein: 26.3), genre: .meet),
        Foodstuff(name: "豚肉", imageName: "pork", gramWeight: 100, nutorient: Nutorient(mineral: 6, vitamin: 1, lipid: 22.7, sugariness: 0.3, protein: 26.7), genre: .meet),
        Foodstuff(name: "牛肉", imageName: "hire", gramWeight: 100, nutorient: Nutorient(mineral: 5, vitamin: 0, lipid: 15.2, sugariness: 0.4, protein: 24.3), genre: .meet),
    ]
    
    let requiredNutorient: Nutorient = Nutorient(mineral: 183, vitamin: 100, lipid: 15, sugariness: 76, protein: 20)
    func getFoodstuffChoises() -> Observable<[Foodstuff]> {
        return Observable.of([
            foodstuffsMaterials[0],
            foodstuffsMaterials[1],
            foodstuffsMaterials[2]
        ])
    }
    
    func calculateNutorientBalance(selected foodstuffs: [Foodstuff]) -> Nutorient {
        let totalNutorient = foodstuffs
            .map { $0.nutorient }
            .reduce(Nutorient(mineral: 0, vitamin: 0, lipid: 0, sugariness: 0, protein: 0)) { (total, value) in
              return total + value
            }
        return totalNutorient / requiredNutorient
    }
}
