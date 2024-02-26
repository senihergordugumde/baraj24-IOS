//
//  cityPickVC.swift
//  baraj24
//
//  Created by Emir AKSU on 7.08.2023.
//

import UIKit
import GoogleMobileAds
import FirebaseCore
import FirebaseFirestore
class cityPickVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: - Variables
    var cities = [String]()
    var selectedCity = String()
    var bannerView: GADBannerView!
    
    
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var shadowBox: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    
    //MARK: - Pickerview delegates
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cities.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return cities[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedCity = cities[row]
        
        navBar.title = selectedCity
        
    }
        
   

    
    
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        callFirebase()
        configurePickerView()
       
       
 
        
    }
    
    //MARK: - PickerView
    func configurePickerView(){
  
            pickerView.setValue(UIColor.label, forKey: "textColor")
            pickerView.delegate = self
            pickerView.dataSource = self
    }
    
    //MARK: - Reklam
    
    
    
    
    //MARK: - Veri Aktarma
    @IBAction func nextButtonClicked(_ sender: Any) {
 
        performSegue(withIdentifier: "toDetails", sender: nil)
   
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDetails"{
            
            let destinationVC = segue.destination as! ViewController
            
            destinationVC.selectedCity = self.selectedCity
            
            
        }
        
    }
    
    //MARK: - Veri Çekme
    private func callFirebase(){
        let firestore = Firestore.firestore()

        firestore.collection("Dams").addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error fetching document: \(error.localizedDescription)")
            } else {
                guard let snapshot = snapshot else {return}
                
                for result in snapshot.documents{
                    
                    self.cities.append(result.documentID)
                }
            }
            self.pickerView.reloadAllComponents()
            self.selectedCity = self.cities[0] // İlk elemanı otomatik olarak seçti.

            }
    }
    
   

}
