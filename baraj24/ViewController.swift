//
//  ViewController.swift
//  baraj24
//
//  Created by Emir AKSU on 7.08.2023.
//

import UIKit
import Charts
import GoogleMobileAds
import WeatherKit
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,ChartViewDelegate {
    var bannerView: GADBannerView!
    var latitude = Double()
    var longitude = Double()
    @IBOutlet weak var rainAlert: UILabel!
    var apiKey = "cede4ab92c568356fd4d3d92a6248ea6"
    var selectedCity = String() // City which was chossen previous section
    var pieChart = PieChartView() // PieChart for showing data
    var avgRates = [Double]() // Dam's average rate
    var ratesSum = Double() // Summary of all dams in a city
    var savedRates = Double() //
    let chartBack = UIView() // Item that behind for PieGraph (Background)
    var selectedDam = String()
    var barajList = [String]()
    var pieChatDamRate = Double()
    var weatherStat = [String]()
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBar: UINavigationItem!
    
    @IBOutlet weak var backGraph: UIView!
    @IBOutlet weak var damRateLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var damRateText: UILabel!
    
    @IBOutlet weak var damRateWarningColor: UIImageView!
    @IBOutlet weak var damRateWarningText: UILabel!
    
    
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
        
        
        
        bannerView = GADBannerView(adSize: GADAdSizeBanner)

        addBannerViewToView(bannerView)

        createTableView()
        
        selectedCity = UserDefaults.standard.object(forKey: "isCitySelected") as! String
       
        
        cityLabel.text = selectedCity
        navBar.title = selectedCity
        
        

        
        if let temp = UserDefaults.standard.object(forKey: "savedRate") as? Double{
            ratesSum = temp
        }
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
       
    }
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
          [NSLayoutConstraint(item: bannerView,
                              attribute: .bottom,
                              relatedBy: .equal,
                              toItem: view.safeAreaLayoutGuide,
                              attribute: .bottom,
                              multiplier: 1,
                              constant: 0),
           NSLayoutConstraint(item: bannerView,
                              attribute: .centerX,
                              relatedBy: .equal,
                              toItem: view,
                              attribute: .centerX,
                              multiplier: 1,
                              constant: 0)
          ])
       }
    override func viewDidAppear(_ animated: Bool) {

       navBar.backButtonTitle = "Şehir Seç"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
       
        weatherRequest()
    }
    
    func weatherRequest(){
        let url = URL(string: "http://api.weatherapi.com/v1/forecast.json?key=f6fc556d51814cd6836161118230510&q=\(self.selectedCity)&days=7")
        
        let sessison = URLSession.shared
        
        if let temp = url{
            let task = sessison.dataTask(with: temp){data,response,error in
                
                if error != nil {
                    print("error1")
                }else{
                    if data != nil{
                        do{
                            let jsonResponse = try JSONSerialization.jsonObject(with: data! , options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:Any]
                            DispatchQueue.main.async {
                                if let forecast = jsonResponse["forecast"] as? [String:Any]{
                                    if let forecastday = forecast["forecastday"] as? [[String:Any]]{
                                        
                                        for i in 0...6{
                                            let dayOne = forecastday[i]
                                            if let day = dayOne["day"] as? [String:Any]{
                                                if let condition = day["condition"] as? [String:Any]{
                                                    self.weatherStat.append(condition["text"] as! String)
                                                }
                                            }
                                        }
                                        if self.weatherStat.contains("Moderate Rain") || self.weatherStat.contains("Patchy rain possible"){
                                            self.rainAlert.text = "Sonraki 7 gün içinde yağış bekleniyor"
                                        }else{
                                            self.rainAlert.text = "Sonraki 7 gün yağış beklenmiyor"
                                        }
                                     
                                        print(self.weatherStat)

                                        
                                      
                                    }
                                }
                            }
                        }catch{
                            print("error2")
                        }
                    }
                }
                
            }
            task.resume()
         
            print(url!)
        }else{
            print("Çökme hatası engellendi.!!")
        }
        
    }
    
    
    func getData(){
        barajList.removeAll()
        tableView.reloadData()
       
        
        
        let url = URL(string: "https://emiraksu.net/wp-content/uploads/data/dataBaraj24.json")
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
                            self.pieChatDamRate = self.ratesSum
                            self.damRateLabel.text = "%" + String(describing: self.ratesSum)
                            
                            UserDefaults.standard.set(self.ratesSum, forKey: "savedRate")
                            
                            if self.ratesSum < 30{
                                self.damRateWarningText.text = "Baraj doluluk oranı tehlikeli seviyede."
                                self.damRateWarningColor.tintColor = .systemRed
                            }else if self.ratesSum > 30 && self.ratesSum < 50 {
                                
                                self.damRateWarningText.text = "Baraj doluluk oranı normal seviyede."
                                self.damRateWarningColor.tintColor = .systemYellow
                            }else{
                                self.damRateWarningText.text = "Baraj doluluk oranı iyi seviyede."
                                
                                self.damRateWarningColor.tintColor = .systemGreen

                            }
                            self.createPieChart()

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

        pieChart.frame = CGRect(x: self.backGraph.frame.width , y: self.backGraph.frame.height , width: 245, height: 245)
        
        
        mainView.addSubview(backGraph)
        mainView.addSubview(pieChart)
       
        pieChart.center = backGraph.center
        var entries = [ChartDataEntry]()
        
      
        entries.append(PieChartDataEntry(value: self.pieChatDamRate, label: "Dolu"))
        entries.append(PieChartDataEntry(value: 100-self.pieChatDamRate, label: "Boş"))

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

