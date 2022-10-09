//
//  ReportTabViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 09/10/22.
//

import UIKit

class ReportTabViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Report"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        initialise()
        setupUI()
        setConstraints()
    }
    
    func initialise() {
    }
    
    func setupUI() {
    }
    
    func setConstraints() {
    }

}
