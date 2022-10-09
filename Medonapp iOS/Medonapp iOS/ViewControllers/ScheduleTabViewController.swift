//
//  ScheduleTabViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 08/10/22.
//

import UIKit

class ScheduleTabViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    private var daysCollectionView: UICollectionView?
    private var scheduleTable: UITableView?
    private var activeDateIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Schedule"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        initialise()
        setupUI()
        setConstraints()
        
        daysCollectionView?.register(ScheduleTabDateCollectionViewCell.nib(), forCellWithReuseIdentifier: ScheduleTabDateCollectionViewCell.identifier)
        daysCollectionView?.delegate = self
        daysCollectionView?.dataSource = self
        
        scheduleTable?.register(ScheduleTabTableViewCell.nib(), forCellReuseIdentifier: ScheduleTabTableViewCell.identifier)
        scheduleTable?.delegate = self
        scheduleTable?.dataSource = self
    }
    
    func initialise() {
    }
    
    func setupUI() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 70, height: 85)
        layout.scrollDirection = .horizontal
        
        daysCollectionView =  UICollectionView(frame: CGRect(x: 0, y: 0, width: 70, height: 85), collectionViewLayout: layout)
        view.addSubview(daysCollectionView!)
        daysCollectionView?.showsHorizontalScrollIndicator = false
        daysCollectionView?.showsVerticalScrollIndicator = false
        
        scheduleTable = UITableView()
        scheduleTable?.separatorStyle = .none
        view.addSubview(scheduleTable!)
    }
    
    func setConstraints() {
        daysCollectionView?.translatesAutoresizingMaskIntoConstraints = false
        scheduleTable?.translatesAutoresizingMaskIntoConstraints = false
        
        daysCollectionView?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        daysCollectionView?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        daysCollectionView?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        daysCollectionView?.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        scheduleTable?.topAnchor.constraint(equalTo: daysCollectionView!.bottomAnchor, constant: 0).isActive = true
        scheduleTable?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        scheduleTable?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        scheduleTable?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
    }
    
    //MARK: CollectionView Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScheduleTabDateCollectionViewCell.identifier, for: indexPath) as! ScheduleTabDateCollectionViewCell
        if indexPath.row == activeDateIndex {
            cell.configure(date: "12", day: "Tue", isActive: true)
        } else {
            cell.configure(date: "12", day: "Tue", isActive: false)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if activeDateIndex == indexPath.row {
            return
        }
        daysCollectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        activeDateIndex = indexPath.row
        refreshCollectionView()
    }
    
    func refreshCollectionView() {
        daysCollectionView?.reloadData()
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
        if indexPath.section == 0 {
            cell.configure(doctorImage: UIImage(named: "cat")!, appointmentTime: "12:30 PM", doctorName: "Dr. Suryansh Sharma", typeOfDoctor: "Cardiologist", cellVariant: .blue)
        } else if indexPath.section == 1 {
            cell.configure(doctorImage: UIImage(named: "cat")!, appointmentTime: "12:30 PM", doctorName: "Dr. Suryansh Sharma", typeOfDoctor: "Cardiologist", cellVariant: .pink)
        } else {
            cell.configure(doctorImage: UIImage(named: "cat")!, appointmentTime: "12:30 PM", doctorName: "Dr. Suryansh Sharma", typeOfDoctor: "Cardiologist", cellVariant: .yellow)
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        scheduleTable?.scrollToRow(at: indexPath, at: .middle, animated: true)
    }
}
