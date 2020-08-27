//
//  SelectFoodstuffView.swift
//  cookpad-internship-2020-summer-pbl
//
//  Created by Ren Matsushita on 2020/08/27.
//  Copyright © 2020 Ren Matsushita. All rights reserved.
//

import UIKit
import RxSwift

final class SelectFoodstuffView: CardView {
    private lazy var headerLabel: UILabel = {
        let label: UILabel = .init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "食材を選ぼう！"
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView: UIStackView = .init()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        return stackView
    }()

    private lazy var refreshButton: UIButton = {
        let refreshButton: UIButton = .init()
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        refreshButton.setTitle("リフレッシュ", for: .normal)
        return refreshButton
    }()
    
    let foodstuffViewTappedSubject: PublishSubject<(CGRect, Foodstuff)> = .init()
    var refreshButtonObservable: Observable<Void> {
        return refreshButton.rx.tap.asObservable()
    }
    let disposeBag: DisposeBag = .init()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(headerLabel)
        addSubview(stackView)
        addSubview(refreshButton)
        
        headerLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        headerLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 24).isActive = true
        refreshButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8).isActive = true
        refreshButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 20).isActive = true
        refreshButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
    }
    
    func configure(with foodstuffs: [Foodstuff]) {
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        stackView.subviews.forEach { view in view.removeFromSuperview() }
        for foodstuff in foodstuffs {
            let foodstuffView: FoodstuffView = FoodstuffView.create()
            stackView.addArrangedSubview(foodstuffView)
            foodstuffView.configure(foodstuff: foodstuff)
            foodstuffView.containerButtonTapped
                .subscribe { _ in
                    // TODO 挙動怪しい
                    let foodstuffViewAbsolutePath = foodstuffView.convert(foodstuffView.imageView.frame, to: self.superview)
                    Console.warning(foodstuffViewAbsolutePath)
                    self.foodstuffViewTappedSubject.onNext((foodstuffViewAbsolutePath, foodstuff))
                }
                .disposed(by: foodstuffView.disposeBag)
        }
    }
}
