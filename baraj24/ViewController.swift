//
//  ViewController.swift
//  baraj24
//
//  Created by Emir AKSU on 7.08.2023.
//

import UIKit
import Charts
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,ChartViewDelegate {
    
    @IBOutlet weak var chartBack: UIView!
    var selectedCity = String()
    var pieChart = PieChartView()
    var avgRates = [Double]()
    var ratesSum = Double()
    var savedRates = Double()
    @IBOutlet weak var navBar: UINavigationItem!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return barajList.count

}
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let bgView = UIView()
        cell.textLabel?.text = barajList[indexPath.row]
        
        
        cell.backgroundColor = UIColor.white
        
        cell.textLabel?.textColor = .black
        bgView.backgroundColor = .tertiaryLabel
        
        cell.selectedBackgroundView  = bgView
        
      
        return cell
    }
    

 
    @IBOutlet weak var tableView: UITableView!
    var barajList = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        chartBack.layer.shadowColor = UIColor.black.cgColor
        chartBack.layer.shadowOffset = CGSize(width: 3, height: 5)
        chartBack.layer.shadowOpacity = 0.5
        chartBack.layer.shadowRadius = 4
     
        
        pieChart.delegate = self
        selectedCity = UserDefaults.standard.object(forKey: "isCitySelected") as! String
       
        
        
        navBar.title = selectedCity
        
        
        

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorColor = .white
        if let temp = UserDefaults.standard.object(forKey: "savedRate") as? Double{
            ratesSum = temp
        }
        
       
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        pieChart.frame = CGRect(x: self.view.frame.width , y: self.view.frame.height , width: 250, height: 250)
        
        
        pieChart.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2 + 150)
        view.addSubview(pieChart)
        
        var entries = [ChartDataEntry]()
        
      
        entries.append(PieChartDataEntry(value: ratesSum, label: "Dolu"))
        entries.append(PieChartDataEntry(value: 100-ratesSum, label: "Boş"))

        let set = PieChartDataSet(entries: entries)
        
        set.colors = ChartColorTemplates.pastel()
        let data = PieChartData(dataSet: set)
        pieChart.data = data
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navBar.backButtonTitle = "Şehir Seç"
       
        getData()
        
        
       
        
    }
    
  
    func getData(){
        barajList.removeAll()
        tableView.reloadData()
       
        
        
        let url = URL(string: "https://emiraksu.net/dataBaraj24.json")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url!) { data, response, error in
            
            if error != nil{
                //alert
            }else{
                if data != nil{
                    do{
                        let jsonResponse = try JSONSerialization.jsonObject(with: data!) as! NSArray
                        
                        DispatchQueue.main.async {
                            if let temp = jsonResponse[2] as? [String: String]{
                                
                                for i in temp{
                                    if i.value == self.selectedCity{
                                        self.barajList.append(i.key)
                                    }
                                }
                                
                                
                                
                                self.tableView.reloadData()
                            }
                            
                            if let temp = jsonResponse[3] as? [String:Any]{
                                for i in temp{
                                   
                                    for a in self.barajList{
                                        
                                        if i.key == a{
                                            if let temp = i.value as? Double{
                                                self.avgRates.append(temp)
                                            }
                                        }
                                    }
                                }
                            }
                            
                            self.ratesSum = 0
                            for i in self.avgRates{
                                self.ratesSum += i
                            }
                            self.ratesSum = self.ratesSum/Double(self.avgRates.count)
                            UserDefaults.standard.set(self.ratesSum, forKey: "savedRate")
                            
                            
                        }
                        
                        
                    }catch{
                        
                    }
                }
            }
            
           
        }
        task.resume()
    }
    
  
    
}

