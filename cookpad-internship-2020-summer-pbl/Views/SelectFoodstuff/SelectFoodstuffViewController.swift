//
//  ViewController.swift
//  cookpad-internship-2020-summer-pbl
//
//  Created by Ren Matsushita on 2020/08/26.
//  Copyright © 2020 Ren Matsushita. All rights reserved.
//

import UIKit
import Charts
import RxSwift
import RxCocoa

final class SelectFoodstuffViewController: UIViewController {
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var baseStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private lazy var radarChartView: RadarChartView = {
        let radarChartView: RadarChartView = .init()
        radarChartView.translatesAutoresizingMaskIntoConstraints = false
        return radarChartView
    }()
    private lazy var collectionView: UICollectionView = {
        return UICollectionView()
    }()
    private lazy var selectFoodstuffView: SelectFoodstuffView = {
        let selectFoodstuffView = SelectFoodstuffView()
        selectFoodstuffView.translatesAutoresizingMaskIntoConstraints = false
        return selectFoodstuffView
    }()
    
    private lazy var viewModel: SelectFoodstuffViewModel = .init(
        model: FoodstuffModel()
    )
    private let disposeBag: DisposeBag = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "食材を選ぼう！"
        configureViews()
        configureLayout()
        viewModel.refreshSubject.onNext(())
        
        selectFoodstuffView
            .foodstuffViewTappedSubject
            .asObservable()
            .subscribe(onNext: { [weak self] imageFrame, foodstuff in
                let selectedFoodstuffImageView = UIImageView(frame: imageFrame)
                self?.view.addSubview(selectedFoodstuffImageView)
                UIView.animate(withDuration: 1, animations: {
                    // それぞれx, yでないと動かないかもしれない
                    selectedFoodstuffImageView.center = self!.radarChartView.center
                    selectedFoodstuffImageView.alpha = 0.1
                }, completion: { _ in
                    self?.viewModel.selectFoodstuffSubject.onNext(foodstuff)
                })
            })
            .disposed(by: disposeBag)
        
        selectFoodstuffView.refreshButtonObservable
            .subscribe { [weak self] _ in
                self?.viewModel.refreshSubject.onNext(())
            }
            .disposed(by: disposeBag)
        
//        viewModel.foodstuffChoises
//            .bind(to: foodstuffChoisesBinder)
//            .disposed(by: disposeBag)
        viewModel.foodstuffChoises
            .subscribe(onNext: { foodstuffs in
                Console.log(foodstuffs)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureViews() {
        view.backgroundColor = AppColor.background
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        contentView.addSubview(baseStackView)
    }
    
    private func configureLayout() {
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        baseStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        baseStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        baseStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        baseStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        baseStackView.addArrangedSubview(radarChartView)
        radarChartView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        view.addSubview(selectFoodstuffView)
        selectFoodstuffView.backgroundColor = .white
        selectFoodstuffView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        selectFoodstuffView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        selectFoodstuffView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
        selectFoodstuffView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
}

extension SelectFoodstuffViewController {
    private var foodstuffChoisesBinder: Binder<[Foodstuff]> {
        return Binder<[Foodstuff]>(self) { me, foodstuffs in
            Console.log(foodstuffs)
            me.selectFoodstuffView.configure(with: foodstuffs)
        }
    }
}
