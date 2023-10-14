//
//  HomeViewController.swift
//  baraj24
//
//  Created by Emir AKSU on 20.08.2023.
//

import Charts
import UIKit
import GoogleMobileAds

class ChartsViewController: UIViewController,ChartViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        datesList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return datesList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
        self.choosenDates = Int(self.datesList[row])!
        self.createLineChart()
    }
    
    
    @IBOutlet weak var pieView: UIView!
    var bannerView: GADBannerView!

    @IBOutlet weak var pickerDate: UIPickerView!
    @IBOutlet weak var damCityLabel: UILabel!
    
    @IBOutlet weak var mainView: UIView!
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
    var choosenDates = 5
    var datesList = ["5","7","10","15","30"]
    @IBOutlet weak var lineChartView: UIView!
    @IBOutlet weak var navBar: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerView = GADBannerView(adSize: GADAdSizeBanner)

        addBannerViewToView(bannerView)
        chartNameLabel.text = annotationTitle
        navBar.title = annotationTitle
        pieChart.delegate = self
        pickerDate.delegate = self
      
        
        getDataForLineChart()
      
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
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getDataForPieChart()
    }
        
    
    
    
    
    func createPieChart(){
        pieChart.frame = CGRect(x: 0, y: 0, width: self.pieView.frame.size.width, height: self.pieView.frame.size.height)
        
        pieChart.center = pieView.center
        mainView.addSubview(pieChart)
        
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
        
        createPieChart()

    }
    
    
    func getDataForPieChart(){
        let url = URL(string: "https://emiraksu.net/wp-content/uploads/data/dataBaraj24.json")
        
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
                                                self.addDataForPieChart()

                                            }
                                        }catch{
                                            print("1hata")
                                        }
                                        
                                        
                                    }
            
        }
        
        task.resume()
        
    }
    
    
    func getDataForLineChart(){
        let url = URL(string: "https://emiraksu.net/wp-content/uploads/data/oldData.json")
        
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
        lineChart.frame = CGRect(x: 0, y: 0, width: self.lineChartView.frame.size.width, height: self.lineChartView.frame.size.height/1.5)
        lineChart.center = lineChartView.center
        mainView.addSubview(lineChart)
        
        
        var entries = [ChartDataEntry]()
        var counter2 = 0
        var counter = 1
        var lastFiveRate = [Double]()
        if doluluk.count >= self.choosenDates{
            lastFiveRate = Array(doluluk.suffix(self.choosenDates))// Son 5 günün doluluk oranları
        }
        
        
        let lastFiveDate = Array(self.tarih.suffix(self.choosenDates)) // Son 5 günün tarihleri
    
        for x in lastFiveRate {  // Son 5 günün doluluk oranları üzerinde döngü başlatıyor.
            for y in stride(from: counter2, to: counter, by: 1){  // 0'dan başlayan bir sayaç başlatır. sayaç barajların doluluk oranlarını tamamen doldurduğuna biter.
                
                entries.append(ChartDataEntry(x: Double(y), y: Double(x)))  // y eksenine baraj doluluk oranını, x eksenine düzlem üzerinde yerleşeceği konumu ekler.
                
                counter += 1
                counter2 += 1
                if counter > lastFiveRate.count{
                    counter = 0
                }
            }
        }
        
  
        let set = LineChartDataSet (entries: entries)
        let data = LineChartData(dataSet: set)
        
        lineChart.data = data
        lineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: lastFiveDate)
        lineChart.xAxis.labelPosition = .bottom // Etiketler altta görünsün
        lineChart.xAxis.labelRotationAngle = -25
        lineChart.data = data
        lineChart.xAxis.granularity = 1.0
        lineChart.isUserInteractionEnabled = false
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
