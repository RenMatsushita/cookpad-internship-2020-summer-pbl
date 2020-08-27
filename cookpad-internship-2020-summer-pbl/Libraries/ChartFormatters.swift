//
//  ChartFormatters.swift
//  cookpad-internship-2020-summer-pbl
//
//  Created by Ren Matsushita on 2020/08/28.
//  Copyright © 2020 Ren Matsushita. All rights reserved.
//

import Charts

final class DataSetValueFormatter: IValueFormatter {
    func stringForValue(_ value: Double,
                        entry: ChartDataEntry,
                        dataSetIndex: Int,
                        viewPortHandler: ViewPortHandler?) -> String {
        return ""
    }
}

final class XAxisFormatter: IAxisValueFormatter {
    
    let titles = [
        "脂質",
        "糖質",
        "タンパク質",
        "ビタミンC",
        "カルシウム",
    ]
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return titles[Int(value) % titles.count]
    }
}
