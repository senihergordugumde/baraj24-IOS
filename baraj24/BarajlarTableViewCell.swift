//
//  BarajlarTableViewCell.swift
//  baraj24
//
//  Created by Emir AKSU on 27.02.2024.
//

import UIKit

class BarajlarTableViewCell: UITableViewCell {

    static let id = "TableViewCell"
    let damText = EALabel(textAlignment: .left, fontSize: 16)
    let damImage = EAImageView(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        
    }
  
    private func configure(){
        
        addSubview(damImage)
        addSubview(damText)
        
        NSLayoutConstraint.activate([
        
            damImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            damImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            damImage.widthAnchor.constraint(equalToConstant: 70),
            damImage.heightAnchor.constraint(equalToConstant: 70),
            
            damText.topAnchor.constraint(equalTo: damImage.topAnchor),
            damText.leadingAnchor.constraint(equalTo: damImage.trailingAnchor, constant: 20),
            damText.widthAnchor.constraint(equalToConstant: 100),
            damText.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    
    func set (dam : Dam){
        self.damText.text = dam.dam_name
        
        
        damImage.getImage(url: dam.image ?? "")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")

    }

}
