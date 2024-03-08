//
//  EAImageView.swift
//  baraj24
//
//  Created by Emir AKSU on 28.02.2024.
//

import UIKit
import FirebaseFirestore
class EAImageView: UIImageView {

    let placeholderImage = UIImage(named: "P4")
    
    override init(frame : CGRect){
        super.init(frame: frame)
        configure()
    }
    
    private func configure(){
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.image = placeholderImage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getImage(url : String){
        
        guard let url = URL(string: url) else {return}
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data else {return}
            
            guard let image = UIImage(data: data) else {return}
            
            DispatchQueue.main.async {
                self.image = image
            }
            
            
        }
        task.resume()
        
        
    }
        
   
    
}
