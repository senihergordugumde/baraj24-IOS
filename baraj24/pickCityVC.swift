//
//  pickCityVC.swift
//  baraj24
//
//  Created by Emir AKSU on 7.08.2023.
//

import UIKit

class pickCityVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var navBar: UINavigationItem!
    
    @IBOutlet weak var shadowBox: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
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
    var city = ["Şehir Seçin"]
    
    
    override func viewDidLoad() {
        
        
        
        
        super.viewDidLoad()
        shadowBox.layer.shadowColor = UIColor.black.cgColor
        shadowBox.layer.shadowOffset = CGSize(width: 3, height: 5)
        shadowBox.layer.shadowOpacity = 0.5
        shadowBox.layer.shadowRadius = 4
        
     
        pickerView.setValue(UIColor.black, forKey: "textColor")
        
        if UserDefaults.standard.value(forKey:"isCitySelected") != nil{
            performSegue(withIdentifier: "toDetails", sender: nil)
        }
        
        let url = URL(string: "https://emiraksu.net/dataBaraj24.json")
        
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
        pickerView.delegate = self
        pickerView.dataSource = self
        
        
        
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
