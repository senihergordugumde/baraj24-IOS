//
//  ViewController.swift
//  baraj24
//
//  Created by Emir AKSU on 7.08.2023.
//

import UIKit
import Charts
import GoogleMobileAds
import FirebaseFirestore

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,ChartViewDelegate {
    var bannerView: GADBannerView!
   
    @IBOutlet weak var rainAlert: UILabel!
    var apiKey = "cede4ab92c568356fd4d3d92a6248ea6"
    var selectedCity = String() // City which was chossen previous section
    var pieChart = PieChartView() // PieChart for showing data
    var avgRates = [Double]() // Dam's average rate
    var ratesSum = Double() // Summary of all dams in a city
    var savedRates = Double() //
    let chartBack = UIView() // Item that behind for PieGraph (Background)
    var selectedDam : Dam?
    var pieChatDamRate = Double()
    var Dams = [Dam]()


    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBar: UINavigationItem!
    
    @IBOutlet weak var backGraph: UIView!
    @IBOutlet weak var damRateLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var damRateText: UILabel!
    
    @IBOutlet weak var damRateWarningColor: UIImageView!
    @IBOutlet weak var damRateWarningText: UILabel!
    
    
    
   
    // MARK: - TableView Delegate , Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Dams.count

    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let bgView = UIView()
        cell.textLabel?.text = Dams[indexPath.row].dam_name
        
        
        cell.backgroundColor = UIColor(named: "Secondary")
        
        cell.textLabel?.textColor = UIColor.label
        
        bgView.backgroundColor = .tertiaryLabel
        
        cell.selectedBackgroundView  = bgView
        
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        self.selectedDam = Dams[indexPath.row]
        
        performSegue(withIdentifier: "toDamDetails", sender: nil)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDamDetails"{
            
            let destinationVC = segue.destination as! ChartsViewController
            
            destinationVC.dam = self.selectedDam
            
            
            
        }
    }
    
    
   // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureBannerAd()
        createTableView()
        getData()
        
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {

       navBar.backButtonTitle = "Şehir Seç"
    }
    
    override func viewWillAppear(_ animated: Bool) {
      
       
    }
    
    // MARK: - ADMOB Banner Settings
    
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
    
    func configureBannerAd(){
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-4730844635676967/9589219055"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    
    
        
    
    
    
    func getData(){
      
        let firestore = Firestore.firestore()
        
        firestore.collection("Dams").document(self.selectedCity).collection("Baraj").addSnapshotListener{ snap, error in
            
            guard let documents = snap?.documents else{ return }
            
            self.Dams = documents.compactMap{(snap) -> Dam? in
                
                do{
                    let dam : Dam
                    
                    dam = try snap.data(as: Dam.self)
                    
                    return dam
                }
                catch{
                    print("DATA PARSE EDİLMEDİ")
                    return nil
                }
                
            }
            
            self.tableView.reloadData()
            
            for dam in self.Dams{
                
                self.pieChatDamRate = (self.pieChatDamRate + dam.rate)
                
            }
            self.pieChatDamRate =  self.pieChatDamRate / Double(self.Dams.count)
            
            self.createPieChart()
            self.damRateLabel.text = String(self.pieChatDamRate)
            
        }
    
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
        
        
        
        self.cityLabel.text = self.selectedCity
        
        
        
    }
  
   
}

