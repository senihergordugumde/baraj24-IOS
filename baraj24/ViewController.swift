//
//  ViewController.swift
//  baraj24
//
//  Created by Emir AKSU on 7.08.2023.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return barajList.count

}
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = barajList[indexPath.row]
        return cell
    }
    

    @IBOutlet weak var tableView: UITableView!
    let barajList = ["Büyükçekmece","Ömerli","Elmalı","Sazlıdere"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
  

}

