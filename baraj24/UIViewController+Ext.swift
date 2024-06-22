//
//  UIViewController+Ext.swift
//  baraj24
//
//  Created by Emir AKSU on 24.02.2024.
//

import Foundation

import UIKit
import Charts

extension UIViewController{
    
    func makeEAAlert(alertTitle : String, alertLabel : String){
        DispatchQueue.main.async {
            let alert = AlertVC(alertTitle: alertTitle, alertLabel: alertLabel)
            
            alert.modalPresentationStyle = .overFullScreen
            alert.modalTransitionStyle = .crossDissolve
            
            
            self.present(alert, animated: true)
        }

        
    }
    
    func createPieChart(dolu : ChartDataEntry, bos: ChartDataEntry,surface : UIView, pieChart : PieChartView){
        
        let set = PieChartDataSet(entries: [dolu,bos])
        
        set.colors = [UIColor.systemBlue,UIColor.systemRed]
        let data = PieChartData(dataSet: set)
        pieChart.data = data
        
        pieChart.legend.enabled = false
        pieChart.animate(xAxisDuration: 1.5,yAxisDuration: 1.5, easingOption: .easeOutBack)
        surface.addSubview(pieChart)
        pieChart.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            pieChart.topAnchor.constraint(equalTo: surface.topAnchor, constant: 55),
            pieChart.centerXAnchor.constraint(equalTo: surface.centerXAnchor),
            pieChart.widthAnchor.constraint(equalToConstant: 200),
            pieChart.heightAnchor.constraint(equalToConstant: 220)
        
        ])

        
    }
    
    
    func createLineChart(data : [ChartDataEntry], surface : UIView, lineChart : LineChartView){
        
        let set = LineChartDataSet(entries: data)
        
        let data = LineChartData(dataSet: set)
        lineChart.data = data
        surface.addSubview(lineChart)
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        
            lineChart.topAnchor.constraint(equalTo: surface.topAnchor, constant: 80),
            lineChart.centerXAnchor.constraint(equalTo: surface.centerXAnchor),
            lineChart.widthAnchor.constraint(equalToConstant: 300),
            lineChart.heightAnchor.constraint(equalToConstant: 300)
        
        ])
        
        set.mode = .horizontalBezier
        set.drawCircleHoleEnabled = false
        set.circleRadius = 5
        set.lineWidth = 5.0
        set.drawFilledEnabled = true
        set.fillColor = NSUIColor.secondaryLabel
       
        
        lineChart.animate(xAxisDuration: CATransaction.animationDuration(),  yAxisDuration:  CATransaction.animationDuration(), easingOption: .linear)
        lineChart.drawGridBackgroundEnabled = false
        lineChart.xAxis.labelPosition = .bottom // Etiketler altta görünsün
        lineChart.xAxis.labelRotationAngle = -25
        lineChart.data = data
        lineChart.xAxis.granularity = 1.0
        lineChart.isUserInteractionEnabled = false
        
        
    }
   
    
    func addBlur() -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemThinMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        return blurEffectView
    }
    
}
