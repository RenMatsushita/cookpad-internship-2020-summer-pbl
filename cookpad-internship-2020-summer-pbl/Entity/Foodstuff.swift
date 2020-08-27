//
//  Foodstuff.swift
//  cookpad-internship-2020-summer-pbl
//
//  Created by Ren Matsushita on 2020/08/27.
//  Copyright © 2020 Ren Matsushita. All rights reserved.
//

struct Foodstuff {
    let name: String
    let imageName: String
    let gramWeight: String
    let mineral: Float
    let vitamin: Float
    // 脂質
    let lipid: Float
    // 糖質
    let sugariness: Float
    // タンパク質
    let protein: Float
    let genre: FoodGenre
    
    enum FoodGenre {
        case vegetable, fish, meet
    }
}
