//
//  HomeViewController.swift
//  baraj24
//
//  Created by Emir AKSU on 20.08.2023.
//

import Charts
import UIKit
import GoogleMobileAds
import FirebaseFirestore
class ChartsViewController: UIViewController,ChartViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    
    var dam : Dam?
    var old_data = [OldData]()
    
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
       

        
        guard let dam = dam else {return}
        
        print(dam.dam_name)
        chartNameLabel.text = dam.dam_name
        navBar.title = dam.dam_name
        pieChart.delegate = self
        pickerDate.delegate = self
      
        
        getDataForLineChart()
        createLineChart()
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-4730844635676967/6479839980"
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
    
    }
    
    
    func getDataForLineChart(){
        
        let firestore = Firestore.firestore()
        
        
        firestore.collection("Dams").document().collection("Baraj").document(dam!.dam_name).collection("oldData").addSnapshotListener{ result,error in
            
        
            guard let documents = result?.documents else {return}
            
            self.old_data = documents.compactMap{ (result) -> OldData? in
                
                do{
                    let data : OldData
                    
                    data = try result.data(as: OldData.self)
                    
                    return data
                }
                
                catch{
                    print("hata")
                    return nil
                }
                
            }
            
            
            
        }
        
    }
    
    
    func createLineChart(){
        lineChart.delegate = self
        lineChart.frame = CGRect(x: 0, y: 0, width: self.lineChartView.frame.size.width, height: self.lineChartView.frame.size.height/1.5)
        lineChart.center = lineChartView.center
        mainView.addSubview(lineChart)
        
        
        var entries = [ChartDataEntry]()
        var dates = [String]()
        for (index,data) in old_data.enumerated(){
            entries.append(ChartDataEntry(x: Double(index), y: Double(data.rate)))  // y eksenine baraj doluluk oranını, x eksenine düzlem üzerinde yerleşeceği konumu ekler.
            
            dates.append(data.date)
        }
      
  
        let set = LineChartDataSet (entries: entries)
        let data = LineChartData(dataSet: set)
        
        lineChart.data = data
        
        lineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: dates)
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
