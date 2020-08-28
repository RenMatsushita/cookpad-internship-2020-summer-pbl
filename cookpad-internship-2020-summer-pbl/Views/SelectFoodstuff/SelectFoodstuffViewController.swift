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
import SafariServices

final class SelectFoodstuffViewController: UIViewController {
    private let searchButtonItem: UIBarButtonItem = .init(barButtonSystemItem: .search, target: self, action: nil)
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
    private let collectionViewDataSource = SelectedFoodstuffCollectionViewDataSource()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: SelectedFoodstuffCollectionViewLayout.create())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self.collectionViewDataSource
        collectionView.register(FoodstuffImageCollectionViewCell.self, forCellWithReuseIdentifier: "selectedFoodstuffCell")
        return collectionView
    }()
    private lazy var selectFoodstuffView: SelectFoodstuffView = {
        let selectFoodstuffView = SelectFoodstuffView()
        selectFoodstuffView.translatesAutoresizingMaskIntoConstraints = false
        return selectFoodstuffView
    }()
    
    private lazy var viewModel: SelectFoodstuffViewModel = .init(
        searchButtonTapped: self.searchButtonItem.rx.tap.asObservable(),
        model: FoodstuffModel()
    )
    private let disposeBag: DisposeBag = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = searchButtonItem
        configureViews()
        configureLayout()
        observeSelectFoodstuffView()
        observeCollectionViewDelegate()
        observeViewModel()
        // 初期選択肢をとってくるためにnextを流す
        viewModel.refreshSubject.onNext(())
    }
    
    private func observeSelectFoodstuffView() {
        selectFoodstuffView
            .foodstuffViewTappedSubject
            .asObservable()
            .subscribe(onNext: { [weak self] imageFrame, foodstuff in
                guard let me = self else {
                    fatalError("me is nil pien")
                }
                let selectedFoodstuffImageView = UIImageView(frame: imageFrame)
                selectedFoodstuffImageView.image = UIImage(named: foodstuff.imageName)
                me.view.addSubview(selectedFoodstuffImageView)
                UIView.animate(withDuration: 0.7, delay: 0, options: [.curveEaseInOut], animations: {
                    selectedFoodstuffImageView.center = me.radarChartView.center
                    selectedFoodstuffImageView.alpha = 0
                }, completion: { _ in
                    selectedFoodstuffImageView.removeFromSuperview()
                    me.viewModel.selectFoodstuffSubject.onNext(foodstuff)
                    UIView.animate(withDuration: 0.15, delay: 0, options: [], animations: {
                        me.radarChartView.transform = CGAffineTransform(scaleX: 1.12, y: 1.12)
                    }, completion: { isComplete in
                        UIView.animate(withDuration: 0.1) {
                            me.radarChartView.transform = CGAffineTransform(scaleX: 1, y: 1)
                            me.viewModel.refreshSubject.onNext(())
                        }
                    })
                })
            })
            .disposed(by: selectFoodstuffView.disposeBag)
        
        selectFoodstuffView.refreshButtonObservable
            .subscribe { [weak self] _ in
                self?.viewModel.refreshSubject.onNext(())
            }
            .disposed(by: disposeBag)
    }
    
    private func observeCollectionViewDelegate() {
        collectionViewDataSource.deleteButtonTapSubject
            .subscribe(onNext: { [weak self] foodstuff in
                self?.viewModel.cancelSelectFoodstuffSubject.onNext(foodstuff)
            })
            .disposed(by: disposeBag)
    }
    
    private func observeViewModel() {
        viewModel.foodstuffChoises
            .bind(to: foodstuffChoisesBinder)
            .disposed(by: disposeBag)
        
        viewModel.radarChartDataSet
            .bind(to: radarChardViewBinder)
            .disposed(by: disposeBag)
        
        viewModel.selectedFoodStuffs
            .bind(to: collectionView.rx.items(dataSource: collectionViewDataSource))
            .disposed(by: disposeBag)
        
        viewModel.showSafariViewControllerSubject
            .bind(to: showSafariViewControllerBinder)
            .disposed(by: disposeBag)
    }
    
    private func configureViews() {
        view.backgroundColor = AppColor.background
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        contentView.addSubview(baseStackView)
        radarChartView.webLineWidth = 1.5
        radarChartView.innerWebLineWidth = 2
        radarChartView.webColor = .darkGray
        radarChartView.innerWebColor = .darkGray

        let xAxis = radarChartView.xAxis
        xAxis.labelFont = .systemFont(ofSize: 9, weight: .bold)
        xAxis.labelTextColor = .black
        xAxis.xOffset = 10
        xAxis.yOffset = 10
        xAxis.valueFormatter = XAxisFormatter()
        
        let yAxis = radarChartView.yAxis
        yAxis.enabled = false
        yAxis.axisMinimum = 0
        yAxis.axisMaximum = 1
        radarChartView.rotationEnabled = false
        radarChartView.legend.enabled = false
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
        baseStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        baseStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        baseStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        baseStackView.addArrangedSubview(radarChartView)
        radarChartView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
        
        baseStackView.addArrangedSubview(collectionView)
        collectionView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.28).isActive = true
        
        view.addSubview(selectFoodstuffView)
        selectFoodstuffView.backgroundColor = .white
        selectFoodstuffView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        selectFoodstuffView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        selectFoodstuffView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.33).isActive = true
        selectFoodstuffView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
}

extension SelectFoodstuffViewController {
    private var foodstuffChoisesBinder: Binder<[Foodstuff]> {
        return Binder<[Foodstuff]>(self) { me, foodstuffs in
            me.selectFoodstuffView.configure(with: foodstuffs)
        }
    }
    
    private var radarChardViewBinder: Binder<RadarChartDataSet> {
        return Binder<RadarChartDataSet>(self) { me, radarChardDataSet in
            radarChardDataSet.fillColor = AppColor.primary
            radarChardDataSet.fillAlpha = 0.5
            radarChardDataSet.colors = [AppColor.primary]
            radarChardDataSet.drawFilledEnabled = true
            let radarChartData = RadarChartData(dataSet: radarChardDataSet)
            radarChartData.setValueFormatter(DataSetValueFormatter())
            me.radarChartView.data = radarChartData
        }
    }
    
    private var showSafariViewControllerBinder: Binder<URL> {
        return Binder<URL>(self) { me, url in
            let safariViewController = SFSafariViewController(url: url)
            me.present(safariViewController, animated: true)
        }
    }
}
