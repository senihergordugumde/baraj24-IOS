//
//  testViewController.swift
//  baraj24
//
//  Created by Emir AKSU on 26.08.2023.
//

import UIKit
import Charts
class testViewController: UIViewController, ChartViewDelegate{
    
    var barajName = "Omerli"
    var tarih = [String]()
    var doluluk = [Double]()
    var baraj = String()
    var barChart = LineChartView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let url = URL(string: "https://emiraksu.net/oldData.json")
        
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 15.0)

        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            
            if error != nil{
                //alert
            }else{
                if data != nil{
                    do{
                        let jsonResponse = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String,Any>
                        
                        DispatchQueue.main.async {
                            
                            if let temp = jsonResponse[self.barajName] as? [String : Any]{
                                
                              
                                self.tarih.append(contentsOf: temp.keys)
                               
                                
                               
                               
                                for i in 0..<self.tarih.count{
                                    print(i)
                                    if let temp2 = temp[self.tarih[i]] as? Double{
                                       
                                        
                                        self.doluluk.append(temp2)
                                        print(self.doluluk)
                                        print(self.tarih)
                                    }
                                }
                                
                                self.chart()
                               
                                
                            }
                
                        }
                    }catch{
                        
                    }
                    
                }
            }
        }
        task.resume()
        
    }
    
   
    override func viewDidAppear(_ animated: Bool) {
        
      
        }
        

  
 
    
    
    
    
    func chart(){
        barChart.delegate = self
        barChart.frame = CGRect(x: 0, y: 0, width: Int(self.view.frame.size.width), height: Int(self.view.frame.size.width))
        barChart.center = view.center
        view.addSubview(barChart)
        
        
        var entries = [ChartDataEntry]()
        
        var counter2 = 0
        var counter = 1
        for x in doluluk {
            
            for y in stride(from: counter2, to: counter, by: 1){
              
                entries.append(ChartDataEntry(x: Double(y), y: Double(x)))
                counter += 1
                counter2 += 1
                if counter > doluluk.count{
                    counter = 0
                }
            }
        
        }
         
            
    
        
        
        let set = LineChartDataSet (entries: entries)
        let data = LineChartData(dataSet: set)
        barChart.data = data
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: self.tarih)
        barChart.xAxis.labelPosition = .bottom // Etiketler altta görünsün
        barChart.xAxis.labelRotationAngle = -25
        barChart.data = data
        barChart.xAxis.granularity = 1.0
       
    }
    
    
}


