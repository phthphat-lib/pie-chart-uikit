//
//  MainVC.swift
//  PieChartSample
//
//  Created by Lucas Pham on 12/7/19.
//  Copyright © 2019 phthphat. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    let vStV: UIStackView = {
        let stV = UIStackView()
        stV.translatesAutoresizingMaskIntoConstraints = false
        stV.axis = .vertical
        stV.alignment = .fill
        stV.distribution = .fillEqually
        stV.spacing = 10
        return stV
    }()
    
    let firstChartV: PieChartView = {
        let chartV = PieChartView()
        chartV.setUpChart([
            PieChartData(percent: 0.3, color: .systemBlue),
            PieChartData(percent: 0.4, color: .systemPink)
        ], type: .full)
        chartV.lineCapStyle = .round
        return chartV
    }()
    
    let secondChartV: PieChartView = {
        let chartV = PieChartView()
        chartV.setUpChart([
            PieChartData(percent: 0.3, color: .systemBlue),
            PieChartData(percent: 0.5, color: .systemYellow, isDash: true),
            PieChartData(percent: 0.2, color: .systemGray, isDash: true)
        ], type: .half)
        return chartV
    }()
    
    let thirdChartV: PieChartView = {
        let chartV = PieChartView()
        chartV.setUpChart([
            PieChartData(percent: 0.3, color: .systemGreen),
            PieChartData(percent: 0.4, color: .systemRed)
        ], type: .full)
        chartV.showDashInside = true
        return chartV
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        //Setup view
        view.addSubview(vStV)
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            vStV.topAnchor.constraint(equalTo: safeArea.topAnchor),
            vStV.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            vStV.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            vStV.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        vStV.addArrangedSubview(firstChartV)
        vStV.addArrangedSubview(secondChartV)
        vStV.addArrangedSubview(thirdChartV)
    }
}
