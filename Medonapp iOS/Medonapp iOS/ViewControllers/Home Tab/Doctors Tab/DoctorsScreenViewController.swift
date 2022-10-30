//
//  DoctorsScreenViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 10/10/22.
//

import UIKit

class DoctorsScreenViewController: UIViewController {
    
    public var doctors: [Doctor] = []
    private var liveDoctors: [Doctor] = []
    
    private var backButton: UIImageView?
    private var navTitle: UILabel?
    private var searchField: SearchBarWithSearchAndFilterIcon?
    private var liveDoctorsLabel: UILabel?
    private var doctorsCollectionView: UICollectionView?
    private var noLiveDoctorsLabel: UILabel?
    private var popularDoctorsLabel: UILabel?
    var doctorsTable: UITableView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Doctors"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationController?.isNavigationBarHidden = true
        
        self.dismissKeyboard()
        
        initialise()
        setupUI()
        setConstraints()
        
        doctorsCollectionView?.register(DoctorsScreenCarouselCollectionViewCell.nib(), forCellWithReuseIdentifier: DoctorsScreenCarouselCollectionViewCell.identifier)
        doctorsCollectionView?.delegate = self
        doctorsCollectionView?.dataSource = self
        
        doctorsTable?.register(DoctorInfoTableViewCell.nib(), forCellReuseIdentifier: DoctorInfoTableViewCell.identifier)
        doctorsTable?.delegate = self
        doctorsTable?.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndexPath = doctorsTable?.indexPathForSelectedRow {
            doctorsTable?.deselectRow(at: selectedIndexPath, animated: animated)
        }
        if let selectedIndexPath = doctorsCollectionView?.indexPathsForSelectedItems?.first {
            doctorsCollectionView?.deselectItem(at: selectedIndexPath, animated: true)
        }
        
        refreshData()
    }
    
    func initialise() {
    }
    
    func setupUI() {
        backButton = UIImageView()
        backButton?.image = UIImage(named: "backIcon_White")?.resizeImageTo(size: CGSize(width: 50, height: 50))
        backButton?.contentMode = .scaleAspectFit
        view.addSubview(backButton!)
        let backTap = UITapGestureRecognizer(target: self, action: #selector(self.handleBackAction(_:)))
        backButton?.addGestureRecognizer(backTap)
        backButton?.isUserInteractionEnabled = true
        
        navTitle = UILabel()
        navTitle?.text = "Doctors"
        navTitle?.textAlignment = .center
        navTitle?.textColor = .black
        navTitle?.font = UIFont(name: "NunitoSans-Bold", size: 18)
        view.addSubview(navTitle!)
        
        searchField = SearchBarWithSearchAndFilterIcon()
        searchField?.setupUI()
        searchField?.delegate = self
        searchField?.setPlaceholder(placeholder: "Search Doctor")
        view.addSubview(searchField!)
        
        liveDoctorsLabel = UILabel()
        liveDoctorsLabel?.text = "Live Doctors"
        liveDoctorsLabel?.textColor = .black
        liveDoctorsLabel?.font = UIFont(name: "NunitoSans-Bold", size: 17)
        view.addSubview(liveDoctorsLabel!)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 93, height: 93)
        layout.scrollDirection = .horizontal
        
        doctorsCollectionView =  UICollectionView(frame: CGRect(x: 0, y: 0, width: 93, height: 93), collectionViewLayout: layout)
        view.addSubview(doctorsCollectionView!)
        doctorsCollectionView?.showsHorizontalScrollIndicator = false
        doctorsCollectionView?.showsVerticalScrollIndicator = false
        
        noLiveDoctorsLabel = UILabel()
        noLiveDoctorsLabel?.text = "No live doctors right now."
        noLiveDoctorsLabel?.textAlignment = .center
        noLiveDoctorsLabel?.textColor = .gray
        noLiveDoctorsLabel?.font = UIFont(name: "NunitoSans-Regular", size: 16)
        view.addSubview(noLiveDoctorsLabel!)
        
        popularDoctorsLabel = UILabel()
        popularDoctorsLabel?.text = "Popular Doctors"
        popularDoctorsLabel?.textColor = .black
        popularDoctorsLabel?.font = UIFont(name: "NunitoSans-Bold", size: 17)
        view.addSubview(popularDoctorsLabel!)
        
        doctorsTable = UITableView()
        doctorsTable?.separatorStyle = .none
        view.addSubview(doctorsTable!)
    }
    
    func setConstraints() {
        backButton?.translatesAutoresizingMaskIntoConstraints = false
        navTitle?.translatesAutoresizingMaskIntoConstraints = false
        searchField?.translatesAutoresizingMaskIntoConstraints = false
        liveDoctorsLabel?.translatesAutoresizingMaskIntoConstraints = false
        doctorsCollectionView?.translatesAutoresizingMaskIntoConstraints = false
        noLiveDoctorsLabel?.translatesAutoresizingMaskIntoConstraints = false
        popularDoctorsLabel?.translatesAutoresizingMaskIntoConstraints = false
        doctorsTable?.translatesAutoresizingMaskIntoConstraints = false
        
        
        backButton?.topAnchor.constraint(equalTo: view.topAnchor, constant: 65).isActive = true
        backButton?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 28).isActive = true
        backButton?.widthAnchor.constraint(equalToConstant: 50).isActive = true
        backButton?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        navTitle?.topAnchor.constraint(equalTo: view.topAnchor, constant: 78).isActive = true
        navTitle?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        navTitle?.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        searchField?.topAnchor.constraint(equalTo: navTitle!.bottomAnchor, constant: 25).isActive = true
        searchField?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 27).isActive = true
        searchField?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -27).isActive = true
        searchField?.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        liveDoctorsLabel?.topAnchor.constraint(equalTo: searchField!.bottomAnchor, constant: 10).isActive = true
        liveDoctorsLabel?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 27).isActive = true
        liveDoctorsLabel?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -27).isActive = true
        
        doctorsCollectionView?.topAnchor.constraint(equalTo: liveDoctorsLabel!.bottomAnchor, constant: 17).isActive = true
        doctorsCollectionView?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 27).isActive = true
        doctorsCollectionView?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -27).isActive = true
        doctorsCollectionView?.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        noLiveDoctorsLabel?.topAnchor.constraint(equalTo: liveDoctorsLabel!.bottomAnchor, constant: 60).isActive = true
        noLiveDoctorsLabel?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 27).isActive = true
        noLiveDoctorsLabel?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -27).isActive = true
        
        popularDoctorsLabel?.topAnchor.constraint(equalTo: doctorsCollectionView!.bottomAnchor, constant: 30).isActive = true
        popularDoctorsLabel?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 27).isActive = true
        popularDoctorsLabel?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -27).isActive = true
        
        doctorsTable?.topAnchor.constraint(equalTo: popularDoctorsLabel!.bottomAnchor, constant: 10).isActive = true
        doctorsTable?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        doctorsTable?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        doctorsTable?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
    }
    
    @objc func handleBackAction(_ sender: UITapGestureRecognizer? = nil) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func refreshData() {
        Doctor.refreshDoctors { isSuccess in
            self.doctors = Doctor.getDoctors()
            self.liveDoctors = Doctor.getLiveDoctors()
            var range = NSMakeRange(0, self.doctorsTable!.numberOfSections)
            var sections = NSIndexSet(indexesIn: range)
            self.doctorsTable!.reloadSections(sections as IndexSet, with: .automatic)
            
            range = NSMakeRange(0, self.doctorsCollectionView!.numberOfSections)
            sections = NSIndexSet(indexesIn: range)
            self.doctorsCollectionView!.reloadSections(sections as IndexSet)
            
            if self.liveDoctors.count < 1 {
                self.noLiveDoctorsLabel?.isHidden = false
            } else {
                self.noLiveDoctorsLabel?.isHidden = true
            }
        }
    }
    
}

extension DoctorsScreenViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension DoctorsScreenViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doctors.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: DoctorInfoTableViewCell.identifier, for: indexPath) as! DoctorInfoTableViewCell
        
        tableCell.configure(doctor: doctors[indexPath.row])
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        doctorsTable?.scrollToRow(at: indexPath, at: .middle, animated: true)
        refreshTableView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let doctorsDetailsVC = UIStoryboard.init(name: "HomeTab", bundle: Bundle.main).instantiateViewController(withIdentifier: "doctorsDetailsVC") as? DoctorDetailsViewViewController
            doctorsDetailsVC?.doctor = self.doctors[indexPath.row]
            self.navigationController?.pushViewController(doctorsDetailsVC!, animated: true)
        }
    }
    
    func refreshTableView() {
        doctorsTable?.reloadData()
    }
}

extension DoctorsScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return liveDoctors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DoctorsScreenCarouselCollectionViewCell.identifier, for: indexPath) as! DoctorsScreenCarouselCollectionViewCell
        
        cell.configure(doctor: liveDoctors[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        doctorsCollectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        refreshCollectionView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let doctorsDetailsVC = UIStoryboard.init(name: "HomeTab", bundle: Bundle.main).instantiateViewController(withIdentifier: "doctorsDetailsVC") as? DoctorDetailsViewViewController
            doctorsDetailsVC?.doctor = self.liveDoctors[indexPath.row]
            self.navigationController?.pushViewController(doctorsDetailsVC!, animated: true)
        }
    }
    
    func refreshCollectionView() {
        doctorsCollectionView?.reloadData()
        
    }
}
