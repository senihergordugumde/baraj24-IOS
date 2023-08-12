//
//  pickCityVC.swift
//  baraj24
//
//  Created by Emir AKSU on 7.08.2023.
//

import UIKit

class pickCityVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var cityLabel: UILabel!
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
        
        cityLabel.text = selectedCity
    }
    
    var addCity = Set<String>()
    
    
    var selectedCity = String()
    var city = ["Şehir Seçin"]
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        let url = URL(string: "https://emiraksu.net/12082023.json")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url!) { data, response, error in
            
            if error != nil{
                let alert = UIAlertController(title: "error", message: "Hata", preferredStyle: .alert)
                
                let okButton = UIAlertAction(title: "OK", style: .default)
                
                alert.addAction(okButton)
                
                self.present(alert,animated: true,completion: nil)
            }else{
                if data != nil{
                    
                    do{
                        let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,Any>
                        
                        DispatchQueue.main.async {
                            
                            if let temp = jsonResponse["Şehir"] as? [String :String]{
                                print(temp.values)
                                
                                for i in temp.values{
                                    self.addCity.insert(i)
                                }
                                
                                for i in self.addCity{
                                   
                                    self.city.append(i)
                                    
                                }
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
        cityLabel.text = city[0]
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    

    @IBAction func nextButtonClicked(_ sender: Any) {
        
        performSegue(withIdentifier: "toTableView", sender: nil)
        
        
    }
    

}
