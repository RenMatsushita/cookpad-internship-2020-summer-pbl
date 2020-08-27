//
//  FoodstuffView.swift
//  cookpad-internship-2020-summer-pbl
//
//  Created by Ren Matsushita on 2020/08/27.
//  Copyright © 2020 Ren Matsushita. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class FoodstuffView: CardView {
    private var foodstuff: Foodstuff!
    @IBOutlet private weak var containerButton: UIButton!
    var containerButtonTapped: Observable<Foodstuff> {
        return containerButton.rx.tap.impactOccurred(.light).map { self.foodstuff }.asObservable()
    }
    let disposeBag: DisposeBag = .init()
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
    }
    
    func configure(foodstuff: Foodstuff) {
        self.foodstuff = foodstuff
        nameLabel.text = foodstuff.name
        imageView.image = UIImage(named: foodstuff.imageName)
    }
}
