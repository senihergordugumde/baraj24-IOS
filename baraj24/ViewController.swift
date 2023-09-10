//
//  ViewController.swift
//  baraj24
//
//  Created by Emir AKSU on 7.08.2023.
//

import UIKit
import Charts
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,ChartViewDelegate {
   
    var selectedCity = String() // City which was chossen previous section
    var pieChart = PieChartView() // PieChart for showing data
    var avgRates = [Double]() // Dam's average rate
    var ratesSum = Double() // Summary of all dams in a city
    var savedRates = Double() //
    let chartBack = UIView() // Item that behind for PieGraph (Background)
    var selectedDam = String()
    var barajList = [String]()
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBar: UINavigationItem!
    
    @IBOutlet weak var backGraph: UIView!
    @IBOutlet weak var damRateLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var damRateText: UILabel!
    
  
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        selectedDam = barajList[indexPath.row]
        performSegue(withIdentifier: "toDamDetails", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDamDetails"{
            
            let destinationVC = segue.destination as! ChartsViewController
            
            destinationVC.annotationTitle = selectedDam
            
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return barajList.count

}
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let bgView = UIView()
        cell.textLabel?.text = barajList[indexPath.row]
        
        
        cell.backgroundColor = UIColor(named: "Secondary")
        
        cell.textLabel?.textColor = UIColor.label
        
        bgView.backgroundColor = .tertiaryLabel
        
        cell.selectedBackgroundView  = bgView
        
      
        return cell
    }
    

 
   
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        
        createTableView()
        
        selectedCity = UserDefaults.standard.object(forKey: "isCitySelected") as! String
       
        
        cityLabel.text = selectedCity
        navBar.title = selectedCity
        
        

        
        if let temp = UserDefaults.standard.object(forKey: "savedRate") as? Double{
            ratesSum = temp
        }
        
       
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
       createPieChart()
       navBar.backButtonTitle = "Şehir Seç"
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
       
        
        
       
        
    }
    
    
    func getData(){
        barajList.removeAll()
        tableView.reloadData()
       
        
        
        let url = URL(string: "https://emiraksu.net/dataBaraj24.json")
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 15.0)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            
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
                            self.ratesSum = floor(self.ratesSum/Double(self.avgRates.count) * 100) / 100.00
                            self.damRateLabel.text = "%" + String(describing: self.ratesSum)
                            UserDefaults.standard.set(self.ratesSum, forKey: "savedRate")
                            
                            
                        }
                        
                        
                    }catch{
                        
                    }
                }
            }
            
           
        }
        task.resume()
    }
    
    func createPieChart(){
        pieChart.delegate = self

        pieChart.frame = CGRect(x: self.backGraph.frame.width , y: self.backGraph.frame.height , width: 300, height: 200)
        
        
        mainView.addSubview(backGraph)
        mainView.addSubview(pieChart)
       
        pieChart.center = backGraph.center
        var entries = [ChartDataEntry]()
        
      
        entries.append(PieChartDataEntry(value: ratesSum, label: "Dolu"))
        entries.append(PieChartDataEntry(value: 100-ratesSum, label: "Boş"))

        let set = PieChartDataSet(entries: entries)
        
        set.colors = ChartColorTemplates.pastel()
        let data = PieChartData(dataSet: set)
        pieChart.data = data
    }
    
    func createTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorColor = .lightGray
    }
  
 
    
}

