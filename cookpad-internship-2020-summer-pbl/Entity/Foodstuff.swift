//
//  Foodstuff.swift
//  cookpad-internship-2020-summer-pbl
//
//  Created by Ren Matsushita on 2020/08/27.
//  Copyright © 2020 Ren Matsushita. All rights reserved.
//

import Foundation

struct Foodstuff: Equatable {
    let id: String = UUID().uuidString
    let name: String
    let imageName: String
    let gramWeight: Float
    let nutorient: Nutorient
    let genre: FoodGenre
    
    enum FoodGenre {
        case vegetable, fish, meet
    }
}
