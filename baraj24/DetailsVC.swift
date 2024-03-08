//
//  DetailsVC.swift
//  baraj24
//
//  Created by Emir AKSU on 24.02.2024.
//

import UIKit
import Charts
import FirebaseFirestore
import GoogleMobileAds

class DetailsVC: UIViewController, ChartViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var bannerView: GADBannerView!

    
    var pieChart = PieChartView()
    var city = String()
    var dams = [Dam]()
    var totalRate = Double()
    var tableView : UITableView?


    
    //MARK: - UI Update
    
    private func updateUI(){
        
        DispatchQueue.main.async{
            self.configurePieGraph()
            self.tableView?.reloadData()
            self.titleRate.text = String("% \(self.totalRate)")
        }
    }
   
    //MARK: - ScrollView
    private let scrollView : UIScrollView = {
        let view = UIScrollView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    
    
    private func configureScrollView(){
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(scrollStackViewContainer)
        
        NSLayoutConstraint.activate([
        
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            scrollStackViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            scrollStackViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor,constant: 10),
            scrollStackViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,constant: -10),
            scrollStackViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollStackViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20)
            
        ])
        
        configureStackView()
    }
    //MARK: - Stack View
    private func configureStackView(){
        
        scrollStackViewContainer.addArrangedSubview(detailsView)
        scrollStackViewContainer.addArrangedSubview(pieGraphView)
        scrollStackViewContainer.addArrangedSubview(tableViewBack)
    }
    
    
    private let scrollStackViewContainer : UIStackView = {
       let view = UIStackView()
       view.spacing = 10
       view.axis = .vertical
       view.translatesAutoresizingMaskIntoConstraints = false
       return view
        
    }()
    
    //MARK: - DetailsView

    
    let detailsView : UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 200).isActive = true
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 10
        
        
        return view
    }()
    
    let titleVeriler = EALabel(textAlignment: .left, fontSize: 16)
    let titleCity = EATitle(textAlignment: .center, fontSize: 20)
    let titleRate = EATitle(textAlignment: .center, fontSize: 20)
    let textDescr = EALabel(textAlignment: .center, fontSize: 12)
    private func configureDetailsView(){
       
        
        //Configure Veriler Text
        detailsView.addSubview(titleVeriler)
        NSLayoutConstraint.activate([
            
            titleVeriler.topAnchor.constraint(equalTo: detailsView.topAnchor, constant: 20),
            titleVeriler.leadingAnchor.constraint(equalTo: detailsView.leadingAnchor, constant: 20),
            titleVeriler.widthAnchor.constraint(equalToConstant: 100),
            titleVeriler.heightAnchor.constraint(equalToConstant: 20)
        
        ])
        titleVeriler.text = "Veriler"
    
        //Configure City Caption
        detailsView.addSubview(titleCity)
        NSLayoutConstraint.activate([
            
            titleCity.topAnchor.constraint(equalTo: detailsView.topAnchor, constant: 55),
            titleCity.centerXAnchor.constraint(equalTo: detailsView.centerXAnchor),
            titleCity.widthAnchor.constraint(equalToConstant: 500),
            titleCity.heightAnchor.constraint(equalToConstant: 20)
        
        ])
     
        titleCity.text = city
        
        //Configure Rate Text
    
        detailsView.addSubview(titleRate)
        
        NSLayoutConstraint.activate([
            
            titleRate.topAnchor.constraint(equalTo: titleCity.topAnchor, constant: 40),
            titleRate.centerXAnchor.constraint(equalTo: detailsView.centerXAnchor),
            titleRate.widthAnchor.constraint(equalToConstant: 90),
            titleRate.heightAnchor.constraint(equalToConstant: 24)
        
        ])
        
     
        titleRate.text = String("% \(self.totalRate)")

        
        //Configure Descr Text
        detailsView.addSubview(textDescr)
        
        NSLayoutConstraint.activate([
            
            textDescr.topAnchor.constraint(equalTo: titleRate.topAnchor, constant: 40),
            textDescr.centerXAnchor.constraint(equalTo: detailsView.centerXAnchor),
            textDescr.widthAnchor.constraint(equalToConstant: 500),
            textDescr.heightAnchor.constraint(equalToConstant: 20)
        
        ])
        
        textDescr.text = "Veriler EPIAS ve ilgili genel müdürlüklerden alınmaktadır"
    }
    
    //MARK: - PieGraph

    private let pieGraphView : UIView = {

        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.heightAnchor.constraint(equalToConstant: 300).isActive = true
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 10

        return view
    }()
    
    let titleGrafik = EALabel(textAlignment: .left, fontSize: 16)
    private func configurePieGraph(){
        
        //Configure Grafik Text
        pieGraphView.addSubview(titleGrafik)
        NSLayoutConstraint.activate([
            
            titleGrafik.topAnchor.constraint(equalTo: pieGraphView.topAnchor, constant: 20),
            titleGrafik.leadingAnchor.constraint(equalTo: pieGraphView.leadingAnchor, constant: 20),
            titleGrafik.widthAnchor.constraint(equalToConstant: 100),
            titleGrafik.heightAnchor.constraint(equalToConstant: 20)
        
        ])
        titleGrafik.text = "Grafik"
        createPieChart(dolu: PieChartDataEntry(value: self.totalRate, label: "Dolu"), bos: PieChartDataEntry(value: 100 - self.totalRate, label: "Boş"), surface: pieGraphView, pieChart: pieChart)
        pieChart.delegate = self

    }
    //MARK: - TableView

    private let tableViewBack : UIView = {

        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 400).isActive = true
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 10
        return view
    }()
    
    
    private func configureTableView(){
        tableView = UITableView()
        guard let tableView = tableView else{return}
        tableViewBack.addSubview(tableView)

       

        
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: tableViewBack.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: tableViewBack.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: tableViewBack.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: tableViewBack.bottomAnchor),

        ])
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .secondarySystemBackground
        tableView.layer.cornerRadius = 10
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(BarajlarTableViewCell.self, forCellReuseIdentifier: BarajlarTableViewCell.id)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BarajlarTableViewCell.id, for: indexPath) as! BarajlarTableViewCell
       
        cell.backgroundColor = .secondarySystemBackground
        cell.set(dam: dams[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let damVC = DamVC()
        damVC.dam = self.dams[indexPath.row]
        self.navigationController?.pushViewController(damVC, animated: true)
        
    }


    
    //MARK: - Fetch Data
    
    private func fetchData(){
        let firestore = Firestore.firestore()
        
        firestore.collection("Dams").document(city).collection("Baraj").addSnapshotListener{ snap, error in
            
            if error != nil{
                print(error?.localizedDescription)
            }
            
            guard let documents = snap?.documents else {
                print(error?.localizedDescription)
                return}
            
    
            self.dams = documents.compactMap{(snap) -> Dam? in
                
                do {
                    let dam : Dam
                    
                    dam = try snap.data(as: Dam.self)
                    
                   
                    return dam
                }
                catch{
                    print("hata")
                    print(error.localizedDescription)
                    return nil
                }
    
                
            }
            // Barajların ortalaması
            self.totalRate = 0.0
            for dam in self.dams{
                self.totalRate = self.totalRate + dam.rate
            }
            self.totalRate = self.totalRate / Double(self.dams.count)
           
            self.updateUI()
        }
       
   
        
       
       
       
    }

    //MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        self.configureScrollView()
        self.configureTableView()
        self.configureDetailsView()
        configureBannerAd()

        view.backgroundColor = .systemBackground
        navigationItem.title = "Baraj24"
        
        
      
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
}
