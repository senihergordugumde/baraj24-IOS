//
//  pickCityVC.swift
//  baraj24
//
//  Created by Emir AKSU on 7.08.2023.
//

import UIKit
import GoogleMobileAds

class pickCityVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var navBar: UINavigationItem!
    var bannerView: GADBannerView!
    @IBOutlet weak var shadowBox: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    func getCityData(){
        let url = URL(string: "https://hand-to-hand-bulkhe.000webhostapp.com/dataBaraj24.json")
        
        
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 15.0)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            
            if error != nil{
                let alert = UIAlertController(title: "error", message: "Hata", preferredStyle: .alert)
                
                let okButton = UIAlertAction(title: "OK", style: .default)
                
                alert.addAction(okButton)
                
                self.present(alert,animated: true,completion: nil)
            }else{
                if data != nil{
                    
                    do{
                        let jsonResponse = try JSONSerialization.jsonObject(with: data!) as! NSArray
                        
                        DispatchQueue.main.async {
                            
                            if let temp = jsonResponse[2] as? [String :String]{
                                print(temp.values)
                                
                                for i in temp.values{
                                    self.addCity.insert(i)
                                }
                                
                                for i in self.addCity{
                                    
                                    self.city.append(i)
                                    
                                    
                                }
                                self.city  = self.city.sorted(by: {$0 < $1})
                                self.pickerView.reloadAllComponents()
                                
                            }
                          
                        }
                        
                    }catch{
                        print("error")
                    }
                    
                }
            }
        }
        task.resume()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return city.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return city[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedCity = city[row]
        
        navBar.title = selectedCity
    
        

        
    }
    
    var addCity = Set<String>()
    
    
    var selectedCity = String()
    var city = [String]()
    
    
    override func viewDidLoad() {
        
        
        
        
        super.viewDidLoad()
    
        
        bannerView = GADBannerView(adSize: GADAdSizeBanner)

        addBannerViewToView(bannerView)
        pickerView.setValue(UIColor.label, forKey: "textColor")
        
        if UserDefaults.standard.value(forKey:"isCitySelected") != nil{
            performSegue(withIdentifier: "toDetails", sender: nil)
        }
        
        
        getCityData()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        city = city.sorted(by: {$0 < $1})
        bannerView.adUnitID = "ca-app-pub-4730844635676967/7298915875"
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
    @IBAction func nextButtonClicked(_ sender: Any) {
        
      
      
        UserDefaults.standard.set(selectedCity, forKey:"isCitySelected")
        
       
        performSegue(withIdentifier: "toDetails", sender: nil)
   
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toTableView"{
            
            let destinationVC = segue.destination as! ViewController
            
            destinationVC.selectedCity = self.selectedCity
            
            
        }
        
    }
    
   

}
