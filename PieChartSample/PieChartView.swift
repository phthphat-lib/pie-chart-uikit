//
//  PieChartWithDash.swift
//  TestChart
//
//  Created by Phthphat on 11/19/19.
//  Copyright © 2019 Phthphat. All rights reserved.
//

import Foundation
import UIKit

class PieChartView: UIView {
    
    private var data: [PieChartData] = []
    var radius: CGFloat = 80
    var lineWidth: CGFloat = 20
    var showDashInside = false
    var padding: CGFloat = 2
    var type: PieChartType = .full
    var lineCapStyle: CGLineCap = .butt
    var remainPercentColor: UIColor = .white
    private let shapeLayer = CAShapeLayer()
    private var multiPath = CGMutablePath()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpViews()
    }
    
    private func setUpViews() {
        self.shapeLayer.path = multiPath
        self.shapeLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(self.shapeLayer)
    }
    
    override func draw(_ rect: CGRect) {
        drawChart(rect: rect)
    }
    
    func setUpChart(_ arrayData: [PieChartData], type: PieChartType, showDashInside: Bool = false) {
        self.data = arrayData
        self.type = type
        self.showDashInside = showDashInside
    }
    func setUpWidth(radius: CGFloat, line: CGFloat, padding: CGFloat = 2) {
        self.radius = radius
        self.lineWidth = line
        self.padding = padding
    }
    
    func drawChart(rect: CGRect) {
        self.multiPath = CGMutablePath()
        let centerPoint = CGPoint(x: (rect.minX + rect.maxX) / 2, y: (rect.minY + rect.maxY) / 2)
        var curAngle: CGFloat = -CGFloat.pi / 2
        var rangeAngle: CGFloat = 0
        switch self.type {
        case .half:
            rangeAngle = CGFloat.pi
            curAngle = CGFloat.pi
        case .full:
            rangeAngle = CGFloat.pi * 2
            curAngle = -CGFloat.pi / 2
        default:
            break
        }
        let endAngle: CGFloat = curAngle + rangeAngle
        
        var listMainPath: [UIBezierPath] = []
        var listInsidePath: [UIBezierPath] = []
        data.forEach { singleData in
            let newAngle = curAngle + singleData.percent * rangeAngle
            let mainPath = UIBezierPath(arcCenter: centerPoint, radius: self.radius, startAngle: curAngle, endAngle: newAngle, clockwise: true)
            listMainPath.append(mainPath)
            
            if self.showDashInside {
                let insidePath = UIBezierPath(arcCenter: centerPoint, radius: self.radius - self.lineWidth - self.padding, startAngle: curAngle, endAngle: newAngle, clockwise: true)
                listInsidePath.append(insidePath)
            }
            curAngle = newAngle
        }
        //Add remain path
        let remainPath = UIBezierPath(arcCenter: centerPoint, radius: self.radius, startAngle: curAngle, endAngle: endAngle, clockwise: true)
        configurePath(path: remainPath, chartData: PieChartData(percent: 0, color: self.remainPercentColor))
        multiPath.addPath(remainPath.cgPath)
        
        var index = 0
        if self.data.count == 0 { return }
        listMainPath.reversed().forEach { path in
            configurePath(path: path, chartData: self.data.reversed()[index], lineCapStyle: self.lineCapStyle)
            multiPath.addPath(path.cgPath)
            index += 1
        }
        index = 0
        listInsidePath.reversed().forEach { path in
            var newChartData = self.data.reversed()[index]
            newChartData.isDash = true
            configurePath(path: path, chartData: newChartData)
            multiPath.addPath(path.cgPath)
            index += 1
        }
    }
    private func configurePath(path: UIBezierPath, chartData: PieChartData, lineCapStyle: CGLineCap = .butt) {
        let  dashes: [ CGFloat ] = [3.0]
        if chartData.isDash {
            path.setLineDash(dashes, count: dashes.count, phase: 0.0)
        }
        
        chartData.color.setStroke()
        path.lineWidth = self.lineWidth
        path.lineCapStyle = lineCapStyle
        path.stroke()
    }
    func reloadView() {
        self.setNeedsDisplay()
    }
}

struct PieChartData {
    var percent: CGFloat
    var color: UIColor
    var isDash = false
    var description = ""
}

enum PieChartType {
    case half, full, unknown
}
