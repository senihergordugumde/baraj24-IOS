//
//  HomeViewController.swift
//  baraj24
//
//  Created by Emir AKSU on 20.08.2023.
//

import Charts
import UIKit

class ChartsViewController: UIViewController,ChartViewDelegate {
    @IBOutlet weak var pieView: UIView!
    
    @IBOutlet weak var damCityLabel: UILabel!
    
    @IBOutlet weak var chartNameLabel: UILabel!
    var pieChart = PieChartView()
    var lineChart = LineChartView()
    var damName = String()
    var damRatesForPieChart = [String:Double]()
    var damCities = [String:String]()
    var annotationTitle = String()
    var currentRate = Double()
    var tarih = [String]()
    var doluluk = [Double]()

    @IBOutlet weak var lineChartView: UIView!
    @IBOutlet weak var navBar: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        chartNameLabel.text = annotationTitle
        navBar.title = annotationTitle
        pieChart.delegate = self
        
      
        getDataForPieChart()
        getDataForLineChart()
        
      
    }
   
    

    override func viewDidAppear(_ animated: Bool) {
        addDataForPieChart()
        createPieChart()
      
    }
        
    
    
    
    func createPieChart(){
        pieChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width/2, height: self.view.frame.size.width/2)
        
        pieChart.center = pieView.center
        view.addSubview(pieChart)
        
        var entries = [ChartDataEntry]()
        
       
        entries.append(PieChartDataEntry(value: currentRate, label: "Dolu"))
        
        entries.append(PieChartDataEntry(value: 100-currentRate, label: "Boş"))
        
        let set = PieChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.pastel()
        let data = PieChartData(dataSet:set)
        
        pieChart.data = data
        
        
    }
    
    func addDataForPieChart (){
        for i in self.damRatesForPieChart{
            if i.key == self.annotationTitle{
                self.currentRate = i.value
            }
        }
        
        for i in self.damCities{
            if i.key == self.annotationTitle{
                self.damCityLabel.text = i.value
            }
        }
    }
    
    
    func getDataForPieChart(){
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
                                                        self.damRatesForPieChart[i.key] = i.value as? Double
                                                        
                                                        
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
                                            }
                                        }catch{
                                            print("1hata")
                                        }
                                        
                                        
                                    }
            
        }
        
        task.resume()
    }
    
    
    func getDataForLineChart(){
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
                            
                            if let temp = jsonResponse[self.annotationTitle] as? [String : Any]{
                                
                                
                                // Tarihi Sıralamak İçin
                                let df = DateFormatter()
                                df.dateFormat = "dd/MM/yyyy"
                                
                                self.tarih.append(contentsOf: temp.keys)
                                self.tarih = self.tarih.sorted {df.date(from: $0)! < df.date(from: $1)!}
                            
                               
                               
                                for i in 0..<self.tarih.count{
                                    if let temp2 = temp[self.tarih[i]] as? Double{
                                       
                                        
                                        self.doluluk.append(temp2)
                                      
                                    }
                                }
                                
                                self.createLineChart()
                               
                                
                            }
                
                        }
                    }catch{
                        
                    }
                    
                }
            }
        }
        task.resume()
    }
    
    
    func createLineChart(){
        lineChart.delegate = self
        lineChart.frame = CGRect(x: 0, y: 0, width: Int(self.view.frame.size.width-40), height: Int(self.view.frame.size.width-40))
        lineChart.center = lineChartView.center
        view.addSubview(lineChart)
        
        
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
        lineChart.data = data
        lineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: self.tarih)
        lineChart.xAxis.labelPosition = .bottom // Etiketler altta görünsün
        lineChart.xAxis.labelRotationAngle = -25
        lineChart.data = data
        lineChart.xAxis.granularity = 1.0
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
