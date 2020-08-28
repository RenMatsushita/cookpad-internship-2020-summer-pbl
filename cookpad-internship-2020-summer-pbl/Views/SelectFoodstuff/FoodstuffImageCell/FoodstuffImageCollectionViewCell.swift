//
//  FoodstuffImageCollectionViewCell.swift
//  cookpad-internship-2020-summer-pbl
//
//  Created by Ren Matsushita on 2020/08/28.
//  Copyright © 2020 Ren Matsushita. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class FoodstuffImageCollectionViewCell: UICollectionViewCell {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: self.contentView.frame)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setImage(UIImage(systemName: "multiply"), for: .normal)
        button.imageEdgeInsets = .init(top: 2, left: 2, bottom: 3, right: 3)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    private var foodstuff: Foodstuff!
    var deleteButtonTapped: Observable<Foodstuff> {
        return deleteButton.rx.tap.impactOccurred(.heavy).map { self.foodstuff }.asObservable()
    }
    var disposeBag: DisposeBag = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(deleteButton)
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        deleteButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = .init()
    }
    
    func configure(with foodstuff: Foodstuff) {
        imageView.image = UIImage(named: foodstuff.imageName)
        self.foodstuff = foodstuff
    }
}
