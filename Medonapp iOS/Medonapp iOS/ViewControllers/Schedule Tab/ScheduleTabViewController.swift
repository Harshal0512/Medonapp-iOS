//
//  ScheduleTabViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 08/10/22.
//

import UIKit
import Toast_Swift

class ScheduleTabViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    private var daysCollectionView: UICollectionView?
    private var scheduleTable: UITableView?
    private var activeDateIndex = 0
    
    private var dates: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
    
    private var appointments: Appointments = []
    private var appointmentsByDate: [Int: [Int]] = [:]
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshData()
    }
    
    @objc func refreshData() {
//        view.showAnimatedGradientSkeleton(transition: .crossDissolve(0.25))
//        monthView?.showAnimatedGradientSkeleton(transition: .crossDissolve(0.25))
        view.makeToastActivity(.center)
        AppointmentElement.refreshAppointments { isSuccess in
            self.view.hideToastActivity()
//            self.monthView?.hideSkeleton(transition: .crossDissolve(0.25))
//            self.view.hideSkeleton(transition: .crossDissolve(0.25))
            self.appointments = AppointmentElement.getAppointments()
//            self.monthView?.resetToToday() //TODO: HERE UPDATE COLLECTION VIEW MONTH
        }
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
        if Calendar.current.component(.month, from: Date()) == 2 {
            return 28 - Calendar.current.component(.day, from: Date().dayBefore)
        }
        else if Calendar.current.component(.month, from: Date()) % 2 == 0 {
            return 30 - Calendar.current.component(.day, from: Date().dayBefore)
        } else {
            return 31 - Calendar.current.component(.day, from: Date().dayBefore)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScheduleTabDateCollectionViewCell.identifier, for: indexPath) as! ScheduleTabDateCollectionViewCell
        
        var dateComponents = DateComponents()
        dateComponents.year = Calendar.current.component(.year, from: Date())
        dateComponents.month = Calendar.current.component(.month, from: Date())
        dateComponents.day = dates[indexPath.row + Calendar.current.component(.day, from: Date().dayBefore)]
        dateComponents.timeZone = TimeZone(abbreviation: "IST")
        
        let userCalendar = Calendar(identifier: .gregorian)
        let date = userCalendar.date(from: dateComponents)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        let dayOfTheWeekString = dateFormatter.string(from: date!)
        if indexPath.row == activeDateIndex {
            cell.configure(date: "\(dates[indexPath.row + Calendar.current.component(.day, from: Date().dayBefore)])", day: dayOfTheWeekString, isActive: true)
        } else {
            cell.configure(date: "\(dates[indexPath.row + Calendar.current.component(.day, from: Date().dayBefore)])", day: dayOfTheWeekString, isActive: false)
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
        AppointmentElement.arrangeAppointmentsByDate(month: Calendar.current.component(.month, from: Date()), year: Calendar.current.component(.year, from: Date()))
        self.appointmentsByDate = AppointmentElement.getAppointmentDate()
        UIView.transition(with: scheduleTable!, duration: 0.15, options: .transitionCrossDissolve, animations: {self.scheduleTable!.reloadData()}, completion: nil)
    }
    
    func refreshCollectionView() {
        daysCollectionView?.reloadData()
    }
    
    
    //MARK: TableView Functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointmentsByDate[dates[activeDateIndex + Calendar.current.component(.day, from: Date().dayBefore)]]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = scheduleTable!.dequeueReusableCell(withIdentifier: ScheduleTabTableViewCell.identifier, for: indexPath) as! ScheduleTabTableViewCell
        
        let array = appointmentsByDate[dates[activeDateIndex + Calendar.current.component(.day, from: Date().dayBefore)]]
        
        if appointments[array![indexPath.row]].doctor?.gender?.lowercased() ?? "male" == "female" {
            cell.configure(appointment: appointments[array![indexPath.row]], cellVariant: .pink)
        }
        else if appointments[array![indexPath.row]].id! % 2 == 0 {
            cell.configure(appointment: appointments[array![indexPath.row]], cellVariant: .blue)
        } else {
            cell.configure(appointment: appointments[array![indexPath.row]], cellVariant: .yellow)
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        scheduleTable?.scrollToRow(at: indexPath, at: .middle, animated: true)
    }
}
