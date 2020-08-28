//
//  Nutorient.swift
//  cookpad-internship-2020-summer-pbl
//
//  Created by Ren Matsushita on 2020/08/28.
//  Copyright © 2020 Ren Matsushita. All rights reserved.
//

import Foundation

struct Nutorient: Equatable {
    let mineral: Double
    let vitamin: Double
    // 脂質 g
    let lipid: Double
    // 糖質 g
    let sugariness: Double
    // タンパク質 g
    let protein: Double
}

func + (lhs: Nutorient, rhs: Nutorient) -> Nutorient {
    return Nutorient(
        mineral: lhs.mineral + rhs.mineral,
        vitamin: lhs.vitamin + rhs.vitamin,
        lipid: lhs.lipid + rhs.lipid,
        sugariness: lhs.sugariness + rhs.sugariness,
        protein: lhs.protein + rhs.protein)
}

func / (lhs: Nutorient, rhs: Nutorient) -> Nutorient {
    return Nutorient(
        mineral: lhs.mineral / rhs.mineral,
        vitamin: lhs.vitamin / rhs.vitamin,
        lipid: lhs.lipid / rhs.lipid,
        sugariness: lhs.sugariness / rhs.sugariness,
        protein: lhs.protein / rhs.protein)
}
