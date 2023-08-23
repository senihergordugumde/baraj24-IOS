//
//  MapsViewController.swift
//  baraj24
//
//  Created by Emir AKSU on 16.08.2023.
//

import UIKit
import MapKit
class MapsViewController: UIViewController, MKMapViewDelegate {
    
    
    
    @IBOutlet weak var mapView: MKMapView!
    var coordinatesLatitude = [String:Any]()
    var coordinatesLongitude = [String:Any]()
    var liste = [String]()
    var annotationTitle = String()
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? MKPointAnnotation{
            annotationTitle = annotation.title!
            performSegue(withIdentifier: "toDetailsMap", sender: nil)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsMap"{
            
            let destinationVC = segue.destination as! ChartsViewController
            
            destinationVC.annotationTitle = annotationTitle
            
        }
    }
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let url = URL(string: "https://emiraksu.net/dataBaraj24.json")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url!){data, response, error in
            if error != nil{
                
            }
            
            if data != nil{
                do{
                    let jsonResponse = try JSONSerialization.jsonObject(with: data!) as! NSArray
                    
                    DispatchQueue.main.async {
                        if let temp = jsonResponse[0] as? [String : Double]{
                            for i in temp{
                                self.coordinatesLatitude[i.key] = i.value
                               
                            }
                           
                            
                        }
                       
                        if let temp = jsonResponse[1] as? [String:Double]{
                            for i in temp{
                                self.coordinatesLongitude[i.key] = i.value
                               
                            }
                        }
                        
                        
                        
                       
                        
                        for i in self.coordinatesLatitude{
                            for a in self.coordinatesLongitude{
                                if i.key == a.key {
                                 
                                    
                                    
                                    let annotation = MKPointAnnotation()
                                    let coordinate = CLLocationCoordinate2D(latitude: i.value as! CLLocationDegrees, longitude: a.value as! CLLocationDegrees)
                                    annotation.coordinate = coordinate
                                    
                                    annotation.title = i.key
                                    
                                    self.mapView.addAnnotation(annotation)
                                }
                            }
                                
                        }
                        
                        
                      
                        
                        
                   
                    }
                }catch{
                    
                }
            }
        }
        task.resume()
        

        
   
  
            
        
        
        
     
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
    }
}
