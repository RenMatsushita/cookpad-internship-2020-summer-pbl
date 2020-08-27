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
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: SelectedFoodstuffCollectionViewLayout.create())
        collectionView.translatesAutoresizingMaskIntoConstraints = true
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "selectedFoodstuffCell")
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
        
        viewModel.foodstuffChoises
            .bind(to: foodstuffChoisesBinder)
            .disposed(by: disposeBag)
        
        viewModel.radarChartDataSet
            .bind(to: radarChardViewBinder)
            .disposed(by: disposeBag)
        // 初期選択肢をとってくるためにnextを流す
        viewModel.refreshSubject.onNext(())
    }
    
    private func configureViews() {
        view.backgroundColor = AppColor.background
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        contentView.addSubview(baseStackView)
        radarChartView.webLineWidth = 1.5
        radarChartView.innerWebLineWidth = 1.5
        radarChartView.webColor = .lightGray
        radarChartView.innerWebColor = .lightGray

        let xAxis = radarChartView.xAxis
        xAxis.labelFont = .systemFont(ofSize: 9, weight: .bold)
        xAxis.labelTextColor = .black
        xAxis.xOffset = 10
        xAxis.yOffset = 10
        xAxis.valueFormatter = XAxisFormatter()
        
        let yAxis = radarChartView.yAxis
        yAxis.enabled = false
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
        baseStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        baseStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        baseStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        baseStackView.addArrangedSubview(radarChartView)
        radarChartView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
        
        view.addSubview(selectFoodstuffView)
        selectFoodstuffView.backgroundColor = .white
        selectFoodstuffView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        selectFoodstuffView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        selectFoodstuffView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.33).isActive = true
        selectFoodstuffView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
}

final class SelectedFoodstuffCollectionViewDataSource: NSObject, RxCollectionViewDataSourceType, UICollectionViewDataSource {
    typealias Element = [Foodstuff]
    var items: Element = []
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, observedEvent: Event<[Foodstuff]>) {
        Binder<Element>(self) { dataSource, element in
            dataSource.items = element
            collectionView.reloadData()
        }.on(observedEvent)
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
            let radarChartData = RadarChartData(dataSet: radarChardDataSet)
            radarChartData.setValueFormatter(DataSetValueFormatter())
            me.radarChartView.data = radarChartData
        }
    }
}

struct SelectedFoodstuffCollectionViewLayout {
    static func create() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            let size = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: size)
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.3),
                heightDimension: .fractionalWidth(0.36))
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitem: item,
                count: 1)
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 20, trailing: 16)
            section.orthogonalScrollingBehavior = .continuous
            let sectionHeaderSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(50))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: sectionHeaderSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
            section.boundarySupplementaryItems = [sectionHeader]
            return section
        }
        return layout
    }
}
