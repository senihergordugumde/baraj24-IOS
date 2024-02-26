//
//  PickCityVC.swift
//  baraj24
//
//  Created by Emir AKSU on 24.02.2024.
//

import UIKit
import FirebaseFirestore
import GoogleMobileAds

class PickCityVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        cities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            
        return cities[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        choosenCity = cities[row]
        self.navigationItem.title = choosenCity

        
    }
    
    var pickerView : UIPickerView?
    var cities = ["Şehir Seçin"]
    var choosenCity : String?
    var bannerView: GADBannerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-4730844635676967/7298915875"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
     
        
  
        

        view.backgroundColor = .secondarySystemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Şehir Seçin"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.forward.to.line"), style: .done, target: self, action: #selector(isCitySelected))
        pickerViewConfigure()
        fetchData()
    }
    
    
    @objc func isCitySelected(){
        guard let choosenCity = choosenCity else {return}
        let detailsVC = DetailsVC()
        detailsVC.city = choosenCity
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    

    private func pickerViewConfigure(){
        
        pickerView = UIPickerView(frame: view.frame)
        
        guard let pickerView = pickerView else{
            return
        }
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        
        view.addSubview(pickerView)
    
    }
    
    
    
    private func fetchData(){
        
        let firestore = Firestore.firestore()
        
        firestore.collection("Dams")
            .addSnapshotListener{ snap, error in
                
            if error != nil{
                print(error?.localizedDescription)
                return
            }
            
            guard let snap = snap else {return}
            
            for data in snap.documents {
                self.cities.append(data.documentID)
            }
       
            self.pickerView?.reloadAllComponents()
        }
        
        
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
    
    
}
