//
//  ScheduleTabViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 08/10/22.
//

import UIKit

class ScheduleTabViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private var scheduleTable: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialise()
        setupUI()
        setConstraints()
        
        scheduleTable?.register(ScheduleTabTableViewCell.nib(), forCellReuseIdentifier: ScheduleTabTableViewCell.identifier)
        scheduleTable?.delegate = self
        scheduleTable?.dataSource = self
    }
    
    func initialise() {
    }
    
    func setupUI() {
        scheduleTable = UITableView()
        scheduleTable?.separatorStyle = .none
        view.addSubview(scheduleTable!)
    }
    
    func setConstraints() {
        scheduleTable?.translatesAutoresizingMaskIntoConstraints = false
        
        scheduleTable?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        scheduleTable?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        scheduleTable?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        scheduleTable?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
    }
    
    
    //MARK: TableView Functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "10:00 AM -------------"
        } else if section == 1 {
            return "11:00 AM -------------"
        } else if section == 2 {
            return "12:00 PM -------------"
        } else {
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = scheduleTable!.dequeueReusableCell(withIdentifier: ScheduleTabTableViewCell.identifier, for: indexPath) as! ScheduleTabTableViewCell
        cell.configure(doctorImage: UIImage(named: "cat")!, appointmentTime: "12:30 PM", doctorName: "Dr. Suryansh Sharma", typeOfDoctor: "Cardiologist")
        
        return cell
    }
}
