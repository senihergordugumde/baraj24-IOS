//
//  HomeViewController.swift
//  baraj24
//
//  Created by Emir AKSU on 20.08.2023.
//

import Charts
import UIKit

class ChartsViewController: UIViewController,ChartViewDelegate {
    
    @IBOutlet weak var damCityLabel: UILabel!
    
    @IBOutlet weak var chartNameLabel: UILabel!
    var pieChart = PieChartView()
    var damRates = [String:Double]()
    var damCities = [String:String]()
    var annotationTitle = String()
    var doluluk = Double()
    
    @IBOutlet weak var navBar: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        chartNameLabel.text = annotationTitle
        navBar.title = annotationTitle
        pieChart.delegate = self
        let url = URL(string: "https://emiraksu.net/dataBaraj24.json")
        
        let session = URLSession.shared
        
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData)
        
        let task = session.dataTask(with: request){data,response,error in
            
            if error != nil{
                print("error")
            }
            
            if data != nil {
                do{
                    let jsonResponse = try JSONSerialization.jsonObject(with: data!) as! NSArray
                    
                    DispatchQueue.main.async {
                        if let temp = jsonResponse[3] as? [String:Any]{
                            
                            for i in temp {
                                self.damRates[i.key] = i.value as? Double
                                
                                
                            }
                            
                            
                            
                        }
                        if let temp = jsonResponse[2] as? [String:String]{
                            
                            for i in temp{
                                self.damCities[i.key] = i.value
                            }
                            
                            
                        }
                        
                        
                        
                        
                        else{
                            print("hata")
                        }
                        
                        for i in self.damRates{
                            if i.key == self.annotationTitle{
                                self.doluluk = i.value
                            }
                            
                            
                        }
                        
                        for i in self.damCities{
                            if i.key == self.annotationTitle{
                                self.damCityLabel.text = i.value
                            }
                        }
                        
                       
                    }
                }catch{
                    print("1hata")
                }
            }
            
        }
        
        task.resume()
    }
   
    override func viewDidAppear(_ animated: Bool) {
        pieChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width)
        
        pieChart.center = view.center
        
        view.addSubview(pieChart)
        
        var entries = [ChartDataEntry]()
        
       
        entries.append(PieChartDataEntry(value: doluluk, label: "Dolu"))
        
        entries.append(PieChartDataEntry(value: 100-doluluk, label: "Boş"))
        
        let set = PieChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.pastel()
        let data = PieChartData(dataSet:set)
        
        pieChart.data = data
    }
        
        
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
